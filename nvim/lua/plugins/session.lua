-- Session persistence is intentionally the only session owner.
-- Restore only for a plain `nvim` started in a project directory.  This keeps
-- Git commit/rebase editors, scripts, stdin and headless checks predictable.
local function project_root(cwd)
	-- Git is authoritative for monorepos: every subdirectory shares the root
	-- session instead of creating a cwd-keyed snapshot of its own.
	local git_root = vim.fs.root(cwd, ".git")
	if git_root then
		return git_root
	end

	-- Non-Git projects have no canonical upward root. Only direct markers count,
	-- keeping an arbitrary directory with a parent package.json opt-in-free.
	local markers = {
		".git",
		"package.json",
		"pnpm-workspace.yaml",
		"go.mod",
		"go.work",
		"Cargo.toml",
		"pyproject.toml",
		"Makefile",
		"CMakeLists.txt",
		"compose.yml",
		"docker-compose.yml",
		"Chart.yaml",
		"helmfile.yaml",
		"helmfile.yml",
		"kustomization.yaml",
		"main.tf",
		"ansible.cfg",
		"global.json",
		"Directory.Build.props",
		".gitlab-ci.yml",
	}
	for _, marker in ipairs(markers) do
		if vim.uv.fs_stat(vim.fs.joinpath(cwd, marker)) then
			return cwd
		end
	end

	-- .NET solutions/projects are the only supported glob markers. Scan one
	-- directory level with libuv; do not descend into child projects.
	local handle = vim.uv.fs_scandir(cwd)
	if handle then
		while true do
			local name, kind = vim.uv.fs_scandir_next(handle)
			if not name then
				break
			end
			if kind == "file" and (name:match("%.sln$") or name:match("%.csproj$")) then
				return cwd
			end
		end
	end
end

local function is_plain_project_start()
	if vim.fn.argc() ~= 0 then
		return false
	end

	local argv = vim.v.argv
	for i, arg in ipairs(argv) do
		if arg == "--headless" or arg == "-e" or arg == "-E" or arg == "-es" or arg == "-b" then
			return false
		end
		if
			arg == "-S"
			or arg == "-c"
			or arg == "--cmd"
			or arg == "--listen"
			or arg == "--remote-ui"
		then
			return false
		end
		-- `nvim --clean` is still interactive, but restoring a user session into
		-- a clean test run is surprising and makes diagnostics non-reproducible.
		if arg == "--clean" or arg == "-u" then
			return false
		end
		if i > 1 and arg:match("^%+") then
			return false
		end
	end

	-- Neovim 0.12 does not expose an `isatty()` Vim function. libuv's handle
	-- classifier is available in supported versions and distinguishes a normal
	-- terminal from piped stdin/headless execution.
	if vim.uv.guess_handle(0) ~= "tty" then
		return false
	end

	local cwd = vim.uv.cwd()
	if not cwd or cwd == vim.env.HOME or cwd == "/" then
		return nil
	end
	return project_root(cwd)
end

-- Workspace state that `mksession` cannot express -----------------------------
-- A session file restores buffers, windows and folds. It cannot restore the
-- Snacks explorer, because that panel is a picker over scratch buffers. The
-- expanded directories and the "panel was open" flag are therefore stored
-- next to the session, keyed by the same cwd+branch name persistence uses.

local state_dir = vim.fs.joinpath(vim.fn.stdpath("state"), "workspace")

--- Windows that must not survive into a session file: restoring them would
--- reopen empty scratch splits instead of the panel they belonged to.
local transient_filetypes = {
	"trouble",
	"OverseerList",
	"neotest-summary",
	"neotest-output-panel",
	"dbui",
	"dbout",
	"snacks_terminal",
	"snacks_picker_input",
	"snacks_picker_list",
	"snacks_picker_preview",
	"snacks_layout_box",
	"edgy",
	"NeogitStatus",
	"DiffviewFiles",
	"DiffviewFileHistory",
}

local function state_path()
	local session = require("persistence").current()
	return vim.fs.joinpath(state_dir, vim.fn.fnamemodify(session, ":t:r") .. ".json")
end

local function read_state()
	local handle = io.open(state_path(), "r")
	if not handle then
		return nil
	end
	local content = handle:read("*a")
	handle:close()
	local ok, decoded = pcall(vim.json.decode, content)
	return (ok and type(decoded) == "table") and decoded or nil
end

local function write_state(data)
	vim.fn.mkdir(state_dir, "p")
	local handle = io.open(state_path(), "w")
	if not handle then
		return
	end
	handle:write(vim.json.encode(data))
	handle:close()
end

local function explorer_pickers()
	local ok, pickers = pcall(function()
		return Snacks.picker.get({ source = "explorer" })
	end)
	return (ok and pickers) or {}
end

--- Directories the user expanded in the explorer, limited to the project. The
--- tree is a Snacks singleton; if it was never loaded there is nothing to save
--- and the previous snapshot must be kept instead of being erased.
local function explorer_open_dirs(root)
	local tree = package.loaded["snacks.explorer.tree"]
	if not tree or type(tree.nodes) ~= "table" then
		return nil
	end
	local prefix = root:gsub("/+$", "") .. "/"
	local dirs = {}
	for path, node in pairs(tree.nodes) do
		if node.dir and node.open and path ~= "" then
			if path == root or path:sub(1, #prefix) == prefix then
				dirs[#dirs + 1] = path
			end
		end
	end
	table.sort(dirs)
	-- A pathological tree must not turn into an unbounded state file.
	while #dirs > 500 do
		table.remove(dirs)
	end
	return dirs
end

--- Snapshot the panel state. persistence fires `SavePre` before it decides
--- whether the session is worth saving, so the snapshot is only written to
--- disk from `SavePost`; otherwise an empty session would erase a good one.
local function collect_workspace()
	local root = vim.uv.cwd()
	if not root then
		return nil
	end
	local previous = read_state() or {}
	return {
		root = root,
		explorer_open = #explorer_pickers() > 0,
		open_dirs = explorer_open_dirs(root) or previous.open_dirs,
		updated = os.time(),
	}
end

--- Close panels before `mksession` runs, so a restored session opens with the
--- editor windows only and the panels are recreated by their own owners.
local function close_transient_windows()
	-- Edgy owns the docked edges; ask it to fold them first so it does not
	-- rebalance the remaining editor windows while they are being closed.
	if package.loaded["edgy"] then
		pcall(function()
			require("edgy").close()
		end)
	end
	for _, picker in ipairs(explorer_pickers()) do
		pcall(function()
			picker:close()
		end)
	end
	local windows = vim.api.nvim_tabpage_list_wins(0)
	for _, win in ipairs(windows) do
		if #vim.api.nvim_tabpage_list_wins(0) <= 1 then
			return
		end
		if
			vim.api.nvim_win_is_valid(win)
			-- Floating windows are never written to a session file, and cursor
			-- animation plugins keep a large pool of them.
			and vim.api.nvim_win_get_config(win).relative == ""
		then
			local buf = vim.api.nvim_win_get_buf(win)
			local transient = vim.bo[buf].buftype ~= ""
				or vim.tbl_contains(transient_filetypes, vim.bo[buf].filetype)
			if transient then
				pcall(vim.api.nvim_win_close, win, true)
			end
		end
	end
end

local function restore_workspace()
	local data = read_state()
	if not data then
		return
	end
	if type(data.open_dirs) == "table" and #data.open_dirs > 0 then
		local ok, tree = pcall(require, "snacks.explorer.tree")
		if ok then
			for _, dir in ipairs(data.open_dirs) do
				if type(dir) == "string" and vim.uv.fs_stat(dir) then
					pcall(function()
						tree:open(dir)
					end)
				end
			end
		end
	end
	if data.explorer_open then
		vim.schedule(function()
			pcall(function()
				Snacks.explorer({
					cwd = vim.uv.cwd(),
					-- The panel takes focus when it opens, so hand it back from
					-- `on_show`, which Snacks calls immediately after that focus:
					-- the cursor ends up in the restored editor window.
					--
					-- Do not pass `focus = false` instead. Snacks resolves a later
					-- `picker:focus()` as `self.opts.focus or "input"`, so a stored
					-- `false` would send every subsequent jump into the panel to
					-- the search prompt rather than to the file list.
					on_show = function(picker)
						if picker.main and vim.api.nvim_win_is_valid(picker.main) then
							pcall(vim.api.nvim_set_current_win, picker.main)
						end
					end,
				})
			end)
		end)
	end
end

return {
	{
		"folke/persistence.nvim",
		event = "VimEnter",
		keys = {
			{
				"<leader>qp",
				function()
					Snacks.picker.projects()
				end,
				desc = "Recent projects",
			},
			{
				"<leader>qw",
				function()
					local snapshot = collect_workspace()
					require("persistence").save()
					if snapshot then
						write_state(snapshot)
					end
					LazyVim.info("Session saved for " .. vim.fn.fnamemodify(vim.uv.cwd(), ":~"))
				end,
				desc = "Save session now",
			},
		},
		opts = {
			need = 1,
			branch = true,
		},
		config = function(_, opts)
			local persistence = require("persistence")
			persistence.setup(opts)

			local group = vim.api.nvim_create_augroup("dotfiles_workspace_state", { clear = true })

			-- persistence fires these before `mksession` and after sourcing a
			-- session, which is exactly where the panel state belongs.
			local pending_workspace

			vim.api.nvim_create_autocmd("User", {
				group = group,
				pattern = "PersistenceSavePre",
				callback = function()
					local ok, snapshot = pcall(collect_workspace)
					pending_workspace = ok and snapshot or nil
					-- Panels are closed before `mksession` so the session file holds
					-- editor windows only; their owners recreate them on load.
					pcall(close_transient_windows)
				end,
			})
			vim.api.nvim_create_autocmd("User", {
				group = group,
				pattern = "PersistenceSavePost",
				callback = function()
					if pending_workspace then
						pcall(write_state, pending_workspace)
						pending_workspace = nil
					end
				end,
			})
			vim.api.nvim_create_autocmd("User", {
				group = group,
				pattern = "PersistenceLoadPost",
				callback = function()
					pcall(restore_workspace)
				end,
			})

			-- Run after LazyVim's dashboard and startup autocmds have settled. The
			-- plugin still saves on VimLeavePre, including :qa and :wqa.
			local root = is_plain_project_start()
			if root then
				vim.schedule(function()
					local session_root = is_plain_project_start()
					if vim.fn.argc() == 0 and session_root then
						if vim.uv.cwd() ~= session_root then
							vim.fn.chdir(session_root)
						end
						persistence.load()
					end
				end)
			end
		end,
	},
}

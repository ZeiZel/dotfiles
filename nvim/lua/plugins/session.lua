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

return {
	{
		"folke/persistence.nvim",
		event = "VimEnter",
		opts = {
			need = 1,
			branch = true,
		},
		config = function(_, opts)
			local persistence = require("persistence")
			persistence.setup(opts)

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

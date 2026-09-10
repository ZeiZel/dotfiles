local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.scrolloff = 8
opt.wrap = false

opt.ignorecase = true
opt.smartcase = true
opt.mouse = "a"
opt.mousefocus = true
opt.clipboard = "unnamedplus"

opt.splitright = true
opt.splitbelow = true
opt.swapfile = false
opt.undofile = true

-- Two spaces are the least surprising default for web, YAML and Lua.
-- Go must use tabs; Rust and C# conventionally use four spaces.
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "go", "gomod", "gowork", "gosum" },
	callback = function()
		vim.opt_local.expandtab = false
		vim.opt_local.shiftwidth = 4
		vim.opt_local.tabstop = 4
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "cs", "rust" },
	callback = function()
		vim.opt_local.expandtab = true
		vim.opt_local.shiftwidth = 4
		vim.opt_local.tabstop = 4
	end,
})

-- ESLint fixes and Prettier are coordinated by LazyVim/Conform.
vim.g.lazyvim_eslint_auto_format = true
-- Do not rewrite vendored or policy-free projects with global Prettier defaults.
vim.g.lazyvim_prettier_needs_config = true

-- IDE chrome ---------------------------------------------------------------
-- The editor should read like Zed/WebStorm: a permanent project header, one
-- global statusline, breadcrumbs in the winbar and a visible window title.

-- Breadcrumbs are owned by dropbar in the winbar. LazyVim would otherwise put
-- the same Trouble symbol trail into lualine and duplicate the information.
vim.g.trouble_lualine = false

-- One statusline for the whole editor, one permanent tab/project header.
opt.laststatus = 3
opt.showtabline = 2

-- Terminal/window title carries project and branch, like the IDE title bar.
opt.title = true
opt.titlelen = 0

-- Cursor: VS Code-like blink in every mode, a thin bar while inserting.
-- Motion between positions is animated by smear-cursor; this is only the shape
-- and the blink cadence, which the terminal renders natively.
opt.guicursor = {
	"n-v-c:block-Cursor/lCursor",
	"i-ci-ve:ver25-Cursor/lCursor",
	"r-cr:hor20-Cursor/lCursor",
	"o:hor50",
	"a:blinkwait700-blinkoff500-blinkon400",
	"sm:block-blinkwait175-blinkoff150-blinkon175",
}

-- Any float that does not ask for its own frame gets the rounded one, so the
-- floating UI is consistent instead of a mix of square and rounded windows.
-- Plugins that pass an explicit border (Snacks, noice, dropbar, smear-cursor)
-- are unaffected.
opt.winborder = "rounded"

opt.pumheight = 12
opt.winminwidth = 12
opt.splitkeep = "screen"

-- Whitespace hints are part of the denser IDE look; keep them low contrast.
opt.list = true
opt.listchars = { tab = "→ ", trail = "·", nbsp = "␣", extends = "›", precedes = "‹" }
opt.fillchars:append({
	vert = "│",
	horiz = "─",
	horizup = "┴",
	horizdown = "┬",
	vertleft = "┤",
	vertright = "├",
	verthoriz = "┼",
})

local title_group = vim.api.nvim_create_augroup("dotfiles_window_title", { clear = true })

vim.api.nvim_create_autocmd({ "BufEnter", "DirChanged", "VimEnter" }, {
	group = title_group,
	callback = function()
		-- LazyVim.root is cached per buffer/cwd, so this stays cheap on BufEnter.
		local ok, root = pcall(function()
			return LazyVim.root.get({ normalize = true })
		end)
		local project = ok and root and vim.fs.basename(root) or vim.fs.basename(vim.uv.cwd() or "")
		local head = vim.g.gitsigns_head
		local file = vim.fn.expand("%:t")
		local parts = { project ~= "" and project or "nvim" }
		if head and head ~= "" then
			parts[#parts + 1] = "⎇ " .. head
		end
		if file ~= "" then
			parts[#parts + 1] = file
		end
		vim.o.titlestring = table.concat(parts, " — ")
	end,
})

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

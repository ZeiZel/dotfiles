-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.cmd("let g:netrw_liststyle = 3")

local opt = vim.opt

opt.relativenumber = true
opt.number = true

-- tabs & indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = false -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one

opt.wrap = false

-- Mouse
opt.mouse = "a"
opt.mousefocus = true

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive

opt.cursorline = true

-- turn on termguicolors for tokyonight colorscheme to work
opt.termguicolors = true
opt.background = "dark" -- colorschemes that can be light or dark will be made dark
opt.signcolumn = "yes" -- show sign column so that text doesn't shift

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard
opt.clipboard = "unnamedplus"

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- turn off swapfile
opt.swapfile = false

-- Tabs
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4

-- Other
opt.scrolloff = 8
opt.wrap = false
opt.termguicolors = true

-- Fillchars
-- opt.fillchars = {
--   vert = "│",
--   fold = "⠀",
--   eob = " ", -- suppress ~ at EndOfBuffer
--   diff = "⣿", -- alternatives = ⣿ ░ ─ ╱
--   msgsep = "‾",
--   foldopen = "▾",
--   foldsep = "│",
--   foldclose = "▸",
-- }

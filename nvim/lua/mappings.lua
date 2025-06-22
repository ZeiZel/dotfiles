require "nvchad.mappings"

local map = vim.keymap.set

-- Leader
vim.g.mapleader = " "

-- INSERT --

map("i", "jj", "<Esc>")

-- NORMAL --

map("n", "<S-Up>", '<cmd>lua MiniMove.move_line("up")<cr>', { desc = "Move - line up" })
map("n", "<S-Down>", '<cmd>lua MiniMove.move_line("down")<cr>', { desc = "Move - line down" })
map("n", "<S-Left>", '<cmd>lua MiniMove.move_line("left")<cr>', { desc = "Move - line left" })
map("n", "<S-Right>", '<cmd>lua MiniMove.move_line("right")<cr>', { desc = "Move - line right" })
map("n", "<S-k>", '<cmd>lua MiniMove.move_line("up")<cr>', { desc = "Move - line up" })
map("n", "<S-j>", '<cmd>lua MiniMove.move_line("down")<cr>', { desc = "Move - line down" })
map("n", "<S-h>", '<cmd>lua MiniMove.move_line("left")<cr>', { desc = "Move - line left" })
map("n", "<S-l>", '<cmd>lua MiniMove.move_line("right")<cr>', { desc = "Move - line right" })

-- Buffers
map("n", "<leader>w", ":w<CR>")

-- Navigation
map("n", "<c-k>", ":wincmd k<CR>")
map("n", "<c-j>", ":wincmd j<CR>")
map("n", "<c-h>", ":wincmd h<CR>")
map("n", "<c-l>", ":wincmd l<CR>")

-- Splits
map("n", "|", ":vsplit<CR>")
map("n", "\\", ":split<CR>")

-- Tabs
map("n", "<Tab>", ":BufferLineCycleNext<CR>")
map("n", "<s-Tab>", ":BufferLineCyclePrev<CR>")

-- VISUAL --

map("v", "<S-Up>", '<cmd>lua MiniMove.move_selection("up")<cr>', { desc = "Move - selection up" })
map("v", "<S-Down>", '<cmd>lua MiniMove.move_selection("down")<cr>', { desc = "Move - selection down" })
map("v", "<S-Left>", '<cmd>lua MiniMove.move_selection("left")<cr>', { desc = "Move - selection left" })
map("v", "<S-Right>", '<cmd>lua MiniMove.move_selection("right")<cr>', { desc = "Move - selection right" })
map("v", "<S-k>", '<cmd>lua MiniMove.move_selection("up")<cr>', { desc = "Move - selection up" })
map("v", "<S-j>", '<cmd>lua MiniMove.move_selection("down")<cr>', { desc = "Move - selection down" })
map("v", "<S-h>", '<cmd>lua MiniMove.move_selection("left")<cr>', { desc = "Move - selection left" })
map("v", "<S-l>", '<cmd>lua MiniMove.move_selection("right")<cr>', { desc = "Move - selection right" })

-- PLUGINS --

-- DBEE
map("n", "<leader>db", ":Dbee open<CR>")

-- Neo-tree
-- map("n", "<leader>e", ":Neotree left toggle reveal<CR>")

-- lsp
map({ "n", "v" }, "<leader>la", "<cmd>Lspsaga code_action<CR>", { desc = "Lsp Code action" })
map({ "n", "v" }, "<leader>lh", "<cmd>Lspsaga hover_doc<CR>", { desc = "Lsp Documentation" })
map({ "n", "v" }, "<leader>ld", "<cmd>Lspsaga show_cursor_diagnostics<CR>", { desc = "Lsp cursor diagnostics" })

-- Telescope
map("n", "<leader>fn", ":Telescope notify<CR>")
map("n", "<leader>fp", ":Telescope projects<CR>")

-- Tagbar
map("n", "<leader>fs", ":Tagbar<CR>")

-- MD Preview
map("n", "<leader>mp", ":MarkdownPreview<CR>")

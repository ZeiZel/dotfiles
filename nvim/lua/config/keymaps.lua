local map = vim.keymap.set

map("i", "jj", "<Esc>", { desc = "Exit insert mode" })
map("n", "<leader>w", "<cmd>write<cr>", { desc = "Save file" })

map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

map("n", "|", "<cmd>vsplit<cr>", { desc = "Vertical split" })
map("n", "\\", "<cmd>split<cr>", { desc = "Horizontal split" })

map("n", "<Tab>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
map("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Previous buffer" })

-- LazyVim already provides LSP, diagnostics, symbols, test and picker mappings.
-- Keeping those defaults prevents mappings to commands from absent plugins.

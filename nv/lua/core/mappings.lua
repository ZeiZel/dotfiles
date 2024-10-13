local map = vim.keymap.set

-- Leader
vim.g.mapleader = " "

-- Insert
map("i", "jj", "<Esc>")

-- Buffers
map("n", "<leader>w", ":w<CR>")

-- Neo-tree
map("n", "<leader>e", ":Neotree left toggle reveal<CR>")

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
map("n", "<leader>x", ":BufferLinePickClose<CR>")
map("n", "<c-x>", ":BufferLineCloseOthers<CR>")

-- Terminal
map("n", "<leader>t", ":ToggleTerm<CR>")
vim.api.nvim_create_autocmd("TermEnter", {
	callback = function()
		-- If the terminal window is lazygit, we do not make changes to avoid clashes
		if string.find(vim.api.nvim_buf_get_name(0), "lazygit") then
			return
		end
		map("t", "<ESC>", function()
			vim.cmd("stopinsert")
		end, { buffer = true })
	end,
})

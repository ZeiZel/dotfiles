-- Leader
vim.g.mapleader = " "

-- Insert
vim.keymap.set("i", "jj", "<Esc>")

-- Buffers
vim.keymap.set("n", "<leader>w", ":w<CR>")

-- Neo-tree
vim.keymap.set("n", "<leader>e", ":Neotree left toggle reveal<CR>")

-- Navigation
vim.keymap.set("n", "<c-k>", ":wincmd k<CR>")
vim.keymap.set("n", "<c-j>", ":wincmd j<CR>")
vim.keymap.set("n", "<c-h>", ":wincmd h<CR>")
vim.keymap.set("n", "<c-l>", ":wincmd l<CR>")

-- Splits
vim.keymap.set("n", "|", ":vsplit<CR>")
vim.keymap.set("n", "\\", ":split<CR>")

-- Tabs
vim.keymap.set("n", "<Tab>", ":bnext<CR>")
vim.keymap.set("n", "<s-Tab>", ":bprev<CR>")

-- Terminal
vim.keymap.set("n", "<leader>t", ":ToggleTerm<CR>")
vim.api.nvim_create_autocmd("TermEnter", {
	callback = function()
		-- If the terminal window is lazygit, we do not make changes to avoid clashes
		if string.find(vim.api.nvim_buf_get_name(0), "lazygit") then return end
		vim.keymap.set("t", "<ESC>", function() vim.cmd "stopinsert" end, { buffer = true })
	end,
})

return {
	n = {
		["<C-\\>"] = { "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" },
		["<leader>bn"] = { "<cmd>tabnew<cr>", desc = "New tab" },
		["<leader>bD"] = {
			function()
				require("astronvim.utils.status").heirline.buffer_picker(
					function(bufnr) require("astronvim.utils.buffer").close(bufnr) end
				)
			end,
			desc = "Pick to close",
		},
		["<leader>b"] = { name = "Buffers" },
		["<leader>w"] = { ":wa!<cr>", desc = "Save File" }, -- change description but the same command
	},
	t = {
		["<esc>"] = { "<C-\\><C-n>", desc = "Terminal normal mode" },
		["jk"] = { "<C-\\><C-n>", desc = "Terminal normal mode" },
	},
}

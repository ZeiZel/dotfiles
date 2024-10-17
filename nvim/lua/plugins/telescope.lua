return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.8",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		require("telescope").setup({
			sorting_strategy = "ascending", -- display results top->bottom
			layout_config = {
				prompt_position = "top", -- search bar at the top
			},
		})
		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
		vim.keymap.set("n", "<leader>fw", builtin.live_grep, {})
		vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
	end,
}
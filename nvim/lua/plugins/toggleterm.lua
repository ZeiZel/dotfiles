return {
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = function()
			require("toggleterm").setup {
				direction = "horizontal",
				size = 10,
				open_mapping = [[<c-\>]],
			}
		end,
	},
}

return {
	-- posting
	{
		"YarikYar/posting.nvim",
		dependencies = { "akinsho/toggleterm.nvim" },
		config = function()
			require("posting").setup({
				border = "curved", -- valid options are "single" | "double" | "shadow" | "curved"
			})
		end,
		event = "BufRead",
		keys = {
			{
				"<leader>lp",
				function()
					require("posting").open()
				end,
				desc = "Open Posting floating window",
			},
		},
	},
	-- lazydocker
	{
		"mgierada/lazydocker.nvim",
		dependencies = { "akinsho/toggleterm.nvim" },
		config = function()
			require("lazydocker").setup({
				border = "curved", -- valid options are "single" | "double" | "shadow" | "curved"
			})
		end,
		event = "BufRead",
		keys = {
			{
				"<leader>ld",
				function()
					require("lazydocker").open()
				end,
				desc = "Open Lazydocker floating window",
			},
		},
	},
}

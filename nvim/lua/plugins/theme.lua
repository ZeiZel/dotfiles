return {
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
		event = "VimEnter",
		config = function()
			require("tokyonight").setup({
				transparent = true,
				styles = {
					sidebars = "transparent", -- style for sidebars, see below
					floats = "transparent",
				},
			})
			vim.cmd([[colorscheme tokyonight]])
		end,
	},
}

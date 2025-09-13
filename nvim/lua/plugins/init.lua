return {
	-- {
	-- 	"ellisonleao/gruvbox.nvim",
	-- 	opts = {
	-- 		transparent_mode = true,
	-- 	},
	-- },
	{
		"tokyonight.nvim",
		opts = {
			style = "storm",
			transparent = true,
			on_colors = function(c)
				c.bg_statusline = c.none
			end,
			on_highlights = function(hl, c)
				hl.TabLineFill = {
					bg = c.none,
				}
			end,

			styles = {
				sidebars = "transparent",
				floats = "transparent",
			},
		},
	},
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "tokyonight",
		},
	},
	{ "nvim-neotest/nvim-nio" },
	{ import = "lazyvim.plugins.extras.lang.typescript" },
	-- { import = "lazyvim.plugins.extras.ui.mini-starter" },
	{ import = "lazyvim.plugins.extras.lang.json" },
	{ import = "lazyvim.plugins.extras.linting.eslint" },
	{ import = "lazyvim.plugins.extras.formatting.prettier" },
}

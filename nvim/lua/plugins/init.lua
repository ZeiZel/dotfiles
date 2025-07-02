return {
	{
		"ellisonleao/gruvbox.nvim",
		opts = {
			transparent_mode = true,
		},
	},
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "gruvbox",
		},
	},
	{ import = "lazyvim.plugins.extras.lang.typescript" },
	{ import = "lazyvim.plugins.extras.ui.mini-starter" },
	{ import = "lazyvim.plugins.extras.lang.json" },
}

return {
	"vuki656/package-info.nvim",
	event = "VeryLazy",
	config = function()
		local package_info = require("package-info")

		require("package-info").setup({
			colors = {
				up_to_date = "#3C4048", -- Text color for up to date dependency virtual text
				outdated = "#d19a66", -- Text color for outdated dependency virtual text
			},
			icons = {
				enable = true, -- Whether to display icons
				style = {
					up_to_date = "|  ", -- Icon for up to date dependencies
					outdated = "|  ", -- Icon for outdated dependencies
				},
			},
			autostart = true, -- Whether to autostart when `package.json` is opened
			hide_up_to_date = false, -- It hides up to date versions when displaying virtual text
			hide_unstable_versions = false, -- It hides unstable versions from version list e.g next-11.1.3-canary3
			package_manager = "npm",
		})

		package_info.get_status()
	end,
}

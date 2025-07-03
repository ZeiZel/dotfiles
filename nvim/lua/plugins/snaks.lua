return {
	{
		"folke/snacks.nvim",
		---@type snacks.Config
		opts = {
			picker = {
				sources = {
					files = { hidden = true, ignored = true },
					grep = { hidden = true },
					explorer = { hidden = true, ignored = true },
				},
			},
		},
	},
}

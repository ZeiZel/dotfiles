return {
	{
		"rcarriga/nvim-notify",
		config = function()
			local notifier = require("notify")
			notifier.setup({
				render = "compact",
				max_height = 20,
				max_width = 80,
				top_down = false,
				animation = "slide",
				fps = 60,
			})
			vim.notify = notifier
		end,
	},
}

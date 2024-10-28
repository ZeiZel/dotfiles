return {
	{
		"rcarriga/nvim-notify",
		config = function()
			local notifier = require("notify")
			notifier.setup({
				render = "default",
				top_down = false,
				animation = "slide",
				fps = 60,
			})
			vim.notify = notifier
		end,
	},
}

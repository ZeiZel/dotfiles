return {
	{
		"rcarriga/nvim-notify",
		config = function()
			local notifier = require("notify")
			notifier.setup({
				render = "default",
				animation = "slide",
				fps = 60,
			})
			vim.notify = notifier
		end,
	},
}

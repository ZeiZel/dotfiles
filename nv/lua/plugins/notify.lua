return {
	{
		"rcarriga/nvim-notify",
		config = function()
			local notifier = require("notify")
			notifier.setup({
				render = "compact",
				animation = "fade",
				fps = 15,
			})
			vim.notify = notifier
		end,
	},
}

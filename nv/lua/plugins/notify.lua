return {
	{
		"rcarriga/nvim-notify",
		config = function()
			local notifier = require("notify")
			notifier.setup({
				render = "compact",
				animation = "fade"
			})
			vim.notify = notifier
		end,
	},
}

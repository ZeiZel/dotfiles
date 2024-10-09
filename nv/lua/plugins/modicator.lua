return {
	{
		'mawkler/modicator.nvim',
		dependencies = 'mawkler/onedark.nvim',
		init = function()
			vim.o.cursorline = true
			vim.o.number = true
			vim.o.termguicolors = true
		end,
		opts = {
			show_warnings = true,
			highlights = {
				defaults = {
					bold = false,
					italic = false,
				},
			},
			integration = {
				lualine = {
					enabled = true,
					highlight = 'bg',
				},
			},
		}
	}
}

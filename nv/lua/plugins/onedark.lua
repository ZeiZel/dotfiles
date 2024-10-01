return {
	"navarasu/onedark.nvim",
	config = function()
		require('onedark').setup({
			transparent = false,
			style = 'deep'
		})
		require('onedark').load()
	end
}

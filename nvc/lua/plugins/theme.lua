return {
	"navarasu/onedark.nvim",
	config = function()
		require("onedark").setup({
			transparent = false,
		})
		require("onedark").load()
	end,
}

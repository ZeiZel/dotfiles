return {
	{
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup({
				"html",
				"css",
				"javascript",
				"typescript",
				"typescriptreact",
				"javascriptreact",
				"lua",
			})
		end,
	},
}

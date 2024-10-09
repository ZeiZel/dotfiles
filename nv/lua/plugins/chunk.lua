-- indents / chunks / lines
return {
	{
		"shellRaining/hlchunk.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("hlchunk").setup({
				chunk = {
					enable = true
				},
				indent = {
					enable = true,
					priority = 10,
					style = { vim.api.nvim_get_hl(0, { name = "Whitespace" }) },
					use_treesitter = false,
					chars = { "┊" },
					ahead_lines = 5,
					delay = 100,
				},
				blank = {
					enable = true,
					priority = 9,
					chars = { "․" },
					style = {
						{ vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID("Whitespace")), "fg", "gui"), "" },
					},
				},
				line_num = {
					enable = true,
					style = "#806d9c",
					priority = 10,
					use_treesitter = true,
				}
			})
		end
	},
}

return {
	{
		"nvim-treesitter/nvim-treesitter",
		config = function()
			require("nvim-treesitter.configs").setup({
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<C-space>",
						node_incremental = "<C-space>",
						scope_incremental = false,
						node_decremental = "<bs>",
					},
				},
				auto_install = true,
				highlight = {
					enable = true,
				},
				indent = { enable = true },
				autotag = {
					enable = true,
				},
				ensure_installed = {
					"go",
					"rust",
					"lua",
					"typescript",
					"javascript",
					"c",
					"tsx",
					"vim",
					"vimdoc",
					"markdown",
					"markdown_inline",

					"json",
					"yaml",
					"html",
					"css",
					"prisma",
					"markdown",
					"markdown_inline",
					"svelte",
					"graphql",
					"bash",
					"dockerfile",
					"gitignore",
					"query",
				},
			})
		end,
	},
}

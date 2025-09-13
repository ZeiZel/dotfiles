return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = {
				-- devops
				"helm",
				"bash",
				"dockerfile",
				"cmake",
				"terraform",
				"hcl",

				-- git
				"git_config",
				"gitcommit",
				"git_rebase",
				"gitignore",
				"gitattributes",

				-- web
				"html",
				"typescript",
				"javascript",
				"tsx",
				"svelte",
				"vue",
				"css",

				-- db
				"prisma",

				-- files
				"json5",
				"yaml",
				"markdown",
				"markdown_inline",

				-- go
				"go",
				"gomod",
				"gowork",
				"gosum",

				-- python
				"python",

				-- sql
				"query",

				-- utils
				"regex",

				-- lua
				"lua",
				"vim",
			},
		},
	},
}

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
				ensure_installed = {
					-- Lua & Vim
					"lua",
					"vim",
					"vimdoc",

					-- JS/TS related
					"tsx",
					"typescript",
					"javascript",
					"astro",
					"svelte",

					-- Web / App related
					"html",
					"css",
					"graphql",

					-- Generic files
					"json",
					"regex",
					"bash",
					"gitignore",
					"markdown",
					"markdown_inline",
					"dockerfile",
					"yaml",
					"prisma",
					"dockerfile",
					"gitignore",
					"bash",
					"query",

					-- another lang
					"go",
					"rust",
					"c",
				},
			})
		end,
	},
}

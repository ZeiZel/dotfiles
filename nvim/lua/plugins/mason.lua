return {
	{
		"mason-org/mason.nvim",
		opts = {
			ensure_installed = {
				-- formattier
				"prettier",
				"hadolint",

				-- devops
				"ansible-lint",
				"cmakelang",
				"cmakelint",
				"tflint",

				-- files
				"markdownlint-cli2",
				"markdown-toc",

				-- go
				"goimports",
				"gofumpt",
				"gomodifytags",
				"impl",
			},
		},
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		opts = {
			ensure_installed = {
				"prettierd",
				"stylua",
				"eslint_d",
			},
		},
	},
	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			"neovim/nvim-lspconfig",
		},
		opts = {
			ensure_installed = {
				"ts_ls",
				"html",
				"cssls",
				"tailwindcss",
				"svelte",
				"lua_ls",
				"graphql",
				"emmet_ls",
				"prismals",
			},
		},
	},
}

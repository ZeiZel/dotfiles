return {
	{
		"qvalentin/helm-ls.nvim",
		-- The upstream plugin only operates on Helm template buffers. The LSP
		-- below still attaches to both Helm templates and chart values files.
		ft = "helm",
		opts = {
			conceal_templates = { enabled = true },
			indent_hints = {
				enabled = true,
				only_for_current_line = true,
			},
			action_highlight = { enabled = true },
		},
	},
	{
		"neovim/nvim-lspconfig",
		optional = true,
		opts = {
			servers = {
				-- The LazyVim Helm extra already owns this one server. These options
				-- extend it; they do not create a second client.
				helm_ls = {
					filetypes = { "helm", "yaml.helm-values" },
					settings = {
						["helm-ls"] = {
							yamlls = { path = "yaml-language-server" },
						},
					},
				},
			},
		},
	},
}

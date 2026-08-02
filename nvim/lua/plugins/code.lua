vim.filetype.add({
	pattern = {
		[".*/%.github/workflows/.*%.ya?ml"] = "yaml.ghaction",
	},
})

return {
	{
		"neovim/nvim-lspconfig",
		optional = true,
		opts = {
			servers = {
				-- GitHub Actions uses a compound filetype so actionlint can be
				-- scoped precisely. Keep the YAML extra's single yamlls client,
				-- but attach it to that compound filetype too.
				yamlls = {
					filetypes = {
						"yaml",
						"yaml.docker-compose",
						"yaml.gitlab",
						"yaml.helm-values",
						"yaml.ghaction",
					},
				},
			},
		},
	},
	{
		"mfussenegger/nvim-lint",
		opts = {
			-- The language extras add their own linters. These are the only
			-- cross-language mappings missing from those extras.
			linters_by_ft = {
				["yaml.ghaction"] = { "actionlint" },
				bash = { "shellcheck" },
				sh = { "shellcheck" },
			},
		},
	},
}

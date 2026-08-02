return {
	{
		"mason-org/mason.nvim",
		opts = {
			ensure_installed = {
				-- Shared formatters and linters. Language extras own their LSPs
				-- and debuggers, keeping Mason as the single installer.
				"actionlint",
				"debugpy",
				"prettierd",
				"shellcheck",
				"tree-sitter-cli",
			},
		},
	},
}

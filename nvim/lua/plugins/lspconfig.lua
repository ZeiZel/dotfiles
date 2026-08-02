return {
	{
		"neovim/nvim-lspconfig",
		opts = {
			-- Keep the buffer readable: signs/underlines stay visible, while
			-- verbose messages are shown only for the current line.
			diagnostics = {
				virtual_text = false,
				virtual_lines = { current_line = true },
				update_in_insert = false,
				severity_sort = true,
			},
			-- Language extras configure TypeScript, Go, Rust, C#, YAML/Helm,
			-- Docker, Ansible, Terraform and SQL. Only shared shell/web/Lua
			-- servers live here to avoid starting duplicate clients.
			servers = {
				bashls = {
					filetypes = { "bash", "sh" },
				},
				html = {},
				cssls = {},
				emmet_language_server = {
					filetypes = {
						"css",
						"html",
						"javascriptreact",
						"less",
						"scss",
						"svelte",
						"typescriptreact",
						"vue",
					},
				},
				lua_ls = {
					settings = {
						Lua = {
							hint = { enable = true },
							workspace = { checkThirdParty = false },
						},
					},
				},
			},
		},
	},
}

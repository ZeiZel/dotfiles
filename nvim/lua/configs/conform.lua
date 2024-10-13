local options = {
				formatters_by_ft = {
					lua = { "stylua" },
					css = { "prettier" },
					html = { "prettier" },
					json = { "prettier" },
					yaml = { "prettier" },
					python = { "isort", "black" },
					rust = { "rustfmt", lsp_format = "fallback" },
					javascript = { "prettier" },
					typescript = { "prettier" },
					javascriptreact = { "prettier" },
					typescriptreact = { "prettier" },
					svelte = { "prettier" },
					markdown = { "prettier" },
					graphql = { "prettier" },
					liquid = { "prettier" },
				},
				format_on_save = {
					lsp_fallback = true,
					timeout_ms = 500,
				},
}

return options

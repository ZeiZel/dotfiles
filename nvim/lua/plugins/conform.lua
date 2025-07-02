return {
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				css = { "prettierd" },
				scss = { "prettierd" },
				html = { "prettierd" },
				json = { "fixjson" },
				yaml = { "yamlfix" },
				sql = { "sql-formatter" },
				javascript = { "prettierd" },
				typescript = { "prettierd" },
				javascriptreact = { "prettierd" },
				typescriptreact = { "prettierd" },
				markdown = { "prettierd" },
			},
			-- format_on_save = {
			--   lsp_fallback = true,
			--   async = false,
			--   timeout_ms = 2000,
			-- },
		},
		init = function()
			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = "*",
				callback = function(args)
					require("conform").format({ bufnr = args.buf })
				end,
			})
		end,
	},
}

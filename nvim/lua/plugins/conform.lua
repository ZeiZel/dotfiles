local prettier_config_files = {
	".prettierrc",
	".prettierrc.cjs",
	".prettierrc.cts",
	".prettierrc.js",
	".prettierrc.json",
	".prettierrc.json5",
	".prettierrc.mjs",
	".prettierrc.mts",
	".prettierrc.toml",
	".prettierrc.ts",
	".prettierrc.yaml",
	".prettierrc.yml",
	"prettier.config.cjs",
	"prettier.config.cts",
	"prettier.config.js",
	"prettier.config.mjs",
	"prettier.config.mts",
	"prettier.config.ts",
}

local function package_has_prettier(path)
	local ok, lines = pcall(vim.fn.readfile, path)
	if not ok then
		return false
	end
	local decoded, package = pcall(vim.json.decode, table.concat(lines, "\n"))
	return decoded and type(package) == "table" and package.prettier ~= nil
end

local function has_prettier_config(_, ctx)
	if
		#vim.fs.find(prettier_config_files, { path = ctx.dirname, upward = true, type = "file" })
		> 0
	then
		return true
	end
	for _, package in
		ipairs(vim.fs.find("package.json", {
			path = ctx.dirname,
			upward = true,
			type = "file",
			limit = 100,
		}))
	do
		if package_has_prettier(package) then
			return true
		end
	end
	return false
end

return {
	{
		"stevearc/conform.nvim",
		opts = {
			-- Project-local tools are preferred where Conform supports them.
			-- LSP formatting is only a fallback, so a file is never formatted
			-- twice by competing providers.
			formatters_by_ft = {
				lua = { "stylua" },
				css = { "prettierd", "prettier", stop_after_first = true },
				scss = { "prettierd", "prettier", stop_after_first = true },
				html = { "prettierd", "prettier", stop_after_first = true },
				json = { "prettierd", "prettier", stop_after_first = true },
				jsonc = { "prettierd", "prettier", stop_after_first = true },
				yaml = { "prettierd", "prettier", stop_after_first = true },
				-- Raw Jinja templates are not valid YAML until rendered.  Do not let
				-- Prettier rewrite control blocks or environment placeholders.
				["yaml.jinja"] = {},
				["yaml.ghaction"] = { "prettierd", "prettier", stop_after_first = true },
				javascript = { "prettierd", "prettier", stop_after_first = true },
				typescript = { "prettierd", "prettier", stop_after_first = true },
				javascriptreact = { "prettierd", "prettier", stop_after_first = true },
				typescriptreact = { "prettierd", "prettier", stop_after_first = true },
				svelte = { "prettierd", "prettier", stop_after_first = true },
				vue = { "prettierd", "prettier", stop_after_first = true },
				markdown = { "prettierd", "prettier", stop_after_first = true },
				["markdown.mdx"] = { "prettierd", "prettier", stop_after_first = true },
			},
			default_format_opts = {
				timeout_ms = 3000,
				async = false,
				quiet = true,
				lsp_format = "fallback",
			},
			formatters = {
				prettierd = {
					condition = has_prettier_config,
				},
			},
		},
	},
}

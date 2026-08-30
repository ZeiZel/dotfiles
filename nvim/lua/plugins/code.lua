local jinja_yaml_syntax =
	vim.api.nvim_create_augroup("dotfiles_jinja_yaml_syntax", { clear = true })

local function enable_jinja_yaml_syntax(bufnr)
	if vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].filetype == "yaml.jinja" then
		vim.api.nvim_buf_call(bufnr, function()
			vim.cmd("setlocal syntax=jinja")
		end)
	end
end

vim.api.nvim_create_autocmd("FileType", {
	group = jinja_yaml_syntax,
	pattern = "yaml.jinja",
	callback = function(args)
		-- LazyVim disables legacy syntax for Tree-sitter filetypes. This small
		-- overlay is the intentional mixed YAML/Jinja renderer for raw templates.
		enable_jinja_yaml_syntax(args.buf)
	end,
})

-- code.lua can load after the current buffer's FileType event. One scheduled
-- check covers that startup ordering without a broad buffer hook.
vim.schedule(function()
	enable_jinja_yaml_syntax(vim.api.nvim_get_current_buf())
end)

vim.filetype.add({
	pattern = {
		[".*/%.github/workflows/.*%.ya?ml"] = "yaml.ghaction",
		-- Jinja templates are rendered into YAML by the project pipeline.  Use a
		-- high-priority content detector so helm-ls.nvim's values.*.yaml rule
		-- cannot classify them as Helm values before we inspect the buffer.
		[".*%.ya?ml"] = {
			function(_, bufnr)
				local control_blocks = {
					"if",
					"elif",
					"else",
					"endif",
					"for",
					"endfor",
					"block",
					"endblock",
					"extends",
					"include",
					"macro",
					"endmacro",
					"set",
					"endset",
				}

				-- Keep detection bounded: filetype probing must stay cheap on large
				-- manifests and should never start an external process.
				for _, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, 200, false)) do
					for _, block in ipairs(control_blocks) do
						if line:find("{%%%-?%s*" .. block .. "%f[%s}]") then
							return "yaml.jinja",
								function(buffer)
									-- LazyVim disables legacy syntax when Tree-sitter is active.
									-- Re-enable the small YAML+Jinja overlay only for this
									-- compound filetype; this does not affect normal YAML/Helm.
									vim.api.nvim_buf_call(buffer, function()
										vim.cmd("setlocal syntax=jinja")
									end)
								end
						end
					end
				end
			end,
			{ priority = 1000 },
		},
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

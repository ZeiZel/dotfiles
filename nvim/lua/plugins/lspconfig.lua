return {
	{
		"neovim/nvim-lspconfig",
		---@class PluginLspOpts
		opts = {
			---@type lspconfig.options
			servers = {
				dockerls = {},
				docker_compose_language_service = {},
				prismals = {},
				ansiblels = {},
				pyright = {},
				neocmake = {},
				helm_ls = {},
				terraformls = {},
				marksman = {},
				eslint = {
					settings = {
						workingDirectories = { mode = "auto" },
						format = auto_format,
					},
				},
				volar = {
					init_options = {
						vue = {
							hybridMode = true,
						},
					},
				},
				vtsls = {},
				svelte = {
					keys = {
						{
							"<leader>co",
							LazyVim.lsp.action["source.organizeImports"],
							desc = "Organize Imports",
						},
					},
					capabilities = {
						workspace = {
							didChangeWatchedFiles = vim.fn.has("nvim-0.10") == 0 and { dynamicRegistration = true },
						},
					},
				},
				jsonls = {
					on_new_config = function(new_config)
						new_config.settings.json.schemas = new_config.settings.json.schemas or {}
						vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
					end,
					settings = {
						json = {
							format = {
								enable = true,
							},
							validate = { enable = true },
						},
					},
				},
				gopls = {
					settings = {
						gopls = {
							gofumpt = true,
							codelenses = {
								gc_details = false,
								generate = true,
								regenerate_cgo = true,
								run_govulncheck = true,
								test = true,
								tidy = true,
								upgrade_dependency = true,
								vendor = true,
							},
							hints = {
								assignVariableTypes = true,
								compositeLiteralFields = true,
								compositeLiteralTypes = true,
								constantValues = true,
								functionTypeParameters = true,
								parameterNames = true,
								rangeVariableTypes = true,
							},
							analyses = {
								nilness = true,
								unusedparams = true,
								unusedwrite = true,
								useany = true,
							},
							usePlaceholders = true,
							completeUnimported = true,
							staticcheck = true,
							directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
							semanticTokens = true,
						},
					},
				},
			},
			---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
			setup = {
				yamlls = function()
					vim.api.nvim_create_autocmd("LspAttach", {
						callback = function(ev)
							local client = vim.lsp.get_client_by_id(ev.data.client_id)
							if client and client.name == "yamlls" and vim.bo[ev.buf].filetype == "helm" then
								vim.schedule(function()
									vim.cmd("LspStop ++force yamlls")
								end)
							end
						end,
					})
				end,
				gopls = function(_, opts)
					vim.api.nvim_create_autocmd("LspAttach", {
						callback = function(ev)
							local client = vim.lsp.get_client_by_id(ev.data.client_id)
							if client and client.name == "gopls" and not client.server_capabilities.semanticTokensProvider then
								local semantic = client.config.capabilities.textDocument.semanticTokens
								client.server_capabilities.semanticTokensProvider = {
									full = true,
									legend = {
										tokenTypes = semantic.tokenTypes,
										tokenModifiers = semantic.tokenModifiers,
									},
									range = true,
								}
							end
						end,
					})
				end,
				eslint = function()
					if not auto_format then
						return
					end

					local function get_client(buf)
						return LazyVim.lsp.get_clients({ name = "eslint", bufnr = buf })[1]
					end

					local formatter = LazyVim.lsp.formatter({
						name = "eslint: lsp",
						primary = false,
						priority = 200,
						filter = "eslint",
					})

					-- Use EslintFixAll on Neovim < 0.10.0
					if not pcall(require, "vim.lsp._dynamic") then
						formatter.name = "eslint: EslintFixAll"
						formatter.sources = function(buf)
							local client = get_client(buf)
							return client and { "eslint" } or {}
						end
						formatter.format = function(buf)
							local client = get_client(buf)
							if client then
								local diag = vim.diagnostic.get(buf,
									{ namespace = vim.lsp.diagnostic.get_namespace(client.id) })
								if #diag > 0 then
									vim.cmd("EslintFixAll")
								end
							end
						end
					end

					-- register the formatter with LazyVim
					LazyVim.format.register(formatter)
				end,
			},
		},
	},
}

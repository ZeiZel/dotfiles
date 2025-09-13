return {
	{
		"nvimtools/none-ls.nvim",
		optional = true,
		opts = function(_, opts)
			local nls = require("null-ls")
			opts.sources = opts.sources or {}

			opts.sources = vim.list_extend(opts.sources or {}, {
				-- docker
				nls.builtins.diagnostics.hadolint,
				-- cmake
				nls.builtins.diagnostics.cmake_lint,
				-- prettier
				nls.builtins.formatting.prettier,
				-- md
				nls.builtins.diagnostics.markdownlint_cli2,

				-- terraform
				nls.builtins.formatting.packer,
				nls.builtins.formatting.terraform_fmt,
				nls.builtins.diagnostics.terraform_validate,
			})
		end,
	},

	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local lint = require("lint")

			lint.linters_by_ft = {
				typescript = { "eslint_d" },
				typescriptreact = { "eslint_d" },
				javascript = { "eslint_d" },
				javascriptreact = { "eslint_d" },
				svelte = { "eslint_d" },
				python = { "pylint" },
				css = { "stylelint" },
				scss = { "stylelint" },
				dockerfile = { "hadolint" },
				cmake = { "cmakelint" },
				markdown = { "markdownlint-cli2" },
			}

			local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
				group = lint_augroup,
				callback = function()
					lint.try_lint()
				end,
			})

			vim.keymap.set("n", "<leader>ll", function()
				lint.try_lint()
			end, { desc = "Trigger linting for current file" })
		end,
	},

	-- {
	-- 	"hrsh7th/nvim-cmp",
	-- 	event = "InsertEnter",
	-- 	dependencies = {
	-- 		"hrsh7th/cmp-emoji",
	-- 		"hrsh7th/cmp-buffer", -- source for text in buffer
	-- 		"hrsh7th/cmp-path", -- source for file system paths
	-- 		{
	-- 			"L3MON4D3/LuaSnip",
	-- 			-- follow latest release.
	-- 			version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
	-- 			-- install jsregexp (optional!).
	-- 			build = "make install_jsregexp",
	-- 		},
	-- 		{ "petertriho/cmp-git", opts = {} },
	-- 		"saadparwaiz1/cmp_luasnip", -- for autocompletion
	-- 		"rafamadriz/friendly-snippets", -- useful snippets
	-- 		"onsails/lspkind.nvim",   -- vs-code like pictograms
	-- 	},
	--
	-- 	opts = function(_, opts)
	-- 		table.insert(opts.sources, { name = "emoji" })
	-- 		table.insert(opts.sources, { name = "git" })
	-- 	end,
	-- 	config = function()
	-- 		local cmp = require("cmp")
	--
	-- 		local luasnip = require("luasnip")
	--
	-- 		local lspkind = require("lspkind")
	--
	-- 		-- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
	-- 		require("luasnip.loaders.from_vscode").lazy_load()
	--
	-- 		cmp.setup({
	-- 			completion = {
	-- 				completeopt = "menu,menuone,preview,noselect",
	-- 			},
	-- 			snippet = { -- configure how nvim-cmp interacts with snippet engine
	-- 				expand = function(args)
	-- 					luasnip.lsp_expand(args.body)
	-- 				end,
	-- 			},
	-- 			mapping = cmp.mapping.preset.insert({
	-- 				["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
	-- 				["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
	-- 				["<C-b>"] = cmp.mapping.scroll_docs(-4),
	-- 				["<C-f>"] = cmp.mapping.scroll_docs(4),
	-- 				["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
	-- 				["<C-e>"] = cmp.mapping.abort(), -- close completion window
	-- 				["<CR>"] = cmp.mapping.confirm({ select = false }),
	-- 			}),
	-- 			-- sources for autocompletion
	-- 			sources = cmp.config.sources({
	-- 				{ name = "nvim_lsp" },
	-- 				{ name = "luasnip" }, -- snippets
	-- 				{ name = "buffer" }, -- text within current buffer
	-- 				{ name = "path" }, -- file system paths
	-- 			}),
	--
	-- 			-- configure lspkind for vs-code like pictograms in completion menu
	-- 			formatting = {
	-- 				format = lspkind.cmp_format({
	-- 					maxwidth = 50,
	-- 					ellipsis_char = "...",
	-- 				}),
	-- 			},
	-- 		})
	-- 	end,
	-- },

	{
		"saghen/blink.cmp",
		version = not vim.g.lazyvim_blink_main and "*",
		build = vim.g.lazyvim_blink_main and "cargo build --release",
		opts_extend = {
			"sources.completion.enabled_providers",
			"sources.compat",
			"sources.default",
		},
		dependencies = {
			"rafamadriz/friendly-snippets",
			-- add blink.compat to dependencies
			{
				"saghen/blink.compat",
				optional = true, -- make optional so it's only enabled if any extras need it
				opts = {},
				version = not vim.g.lazyvim_blink_main and "*",
			},
		},
		event = "InsertEnter",

		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			snippets = {
				expand = function(snippet, _)
					return LazyVim.cmp.expand(snippet)
				end,
			},
			appearance = {
				-- sets the fallback highlight groups to nvim-cmp's highlight groups
				-- useful for when your theme doesn't support blink.cmp
				-- will be removed in a future release, assuming themes add support
				use_nvim_cmp_as_default = false,
				-- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- adjusts spacing to ensure icons are aligned
				nerd_font_variant = "mono",
			},
			completion = {
				accept = {
					-- experimental auto-brackets support
					auto_brackets = {
						enabled = true,
					},
				},
				menu = {
					draw = {
						treesitter = { "lsp" },
					},
				},
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 200,
				},
				ghost_text = {
					enabled = vim.g.ai_cmp,
				},
			},

			-- experimental signature help support
			-- signature = { enabled = true },

			sources = {
				-- adding any nvim-cmp sources here will enable them
				-- with blink.compat
				compat = {},
				default = { "lsp", "path", "snippets", "buffer" },
			},

			cmdline = {
				enabled = false,
			},

			keymap = {
				preset = "enter",
				["<C-y>"] = { "select_and_accept" },
			},
		},
		---@param opts blink.cmp.Config | { sources: { compat: string[] } }
		config = function(_, opts)
			-- setup compat sources
			local enabled = opts.sources.default
			for _, source in ipairs(opts.sources.compat or {}) do
				opts.sources.providers[source] = vim.tbl_deep_extend(
					"force",
					{ name = source, module = "blink.compat.source" },
					opts.sources.providers[source] or {}
				)
				if type(enabled) == "table" and not vim.tbl_contains(enabled, source) then
					table.insert(enabled, source)
				end
			end

			-- add ai_accept to <Tab> key
			if not opts.keymap["<Tab>"] then
				if opts.keymap.preset == "super-tab" then -- super-tab
					opts.keymap["<Tab>"] = {
						require("blink.cmp.keymap.presets")["super-tab"]["<Tab>"][1],
						LazyVim.cmp.map({ "snippet_forward", "ai_accept" }),
						"fallback",
					}
				else -- other presets
					opts.keymap["<Tab>"] = {
						LazyVim.cmp.map({ "snippet_forward", "ai_accept" }),
						"fallback",
					}
				end
			end

			-- Unset custom prop to pass blink.cmp validation
			opts.sources.compat = nil

			-- check if we need to override symbol kinds
			for _, provider in pairs(opts.sources.providers or {}) do
				---@cast provider blink.cmp.SourceProviderConfig|{kind?:string}
				if provider.kind then
					local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
					local kind_idx = #CompletionItemKind + 1

					CompletionItemKind[kind_idx] = provider.kind
					---@diagnostic disable-next-line: no-unknown
					CompletionItemKind[provider.kind] = kind_idx

					---@type fun(ctx: blink.cmp.Context, items: blink.cmp.CompletionItem[]): blink.cmp.CompletionItem[]
					local transform_items = provider.transform_items
					---@param ctx blink.cmp.Context
					---@param items blink.cmp.CompletionItem[]
					provider.transform_items = function(ctx, items)
						items = transform_items and transform_items(ctx, items) or items
						for _, item in ipairs(items) do
							item.kind = kind_idx or item.kind
							item.kind_icon = LazyVim.config.icons.kinds[item.kind_name] or item.kind_icon or nil
						end
						return items
					end

					-- Unset custom prop to pass blink.cmp validation
					provider.kind = nil
				end
			end

			require("blink.cmp").setup(opts)
		end,
	},
}

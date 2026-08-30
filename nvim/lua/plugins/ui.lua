return {
	{
		"akinsho/bufferline.nvim",
		-- LazyVim owns setup (including its session-restore workaround). Keep the
		-- override lazy and only adjust visibility after Bufferline/Snacks settle.
		init = function()
			local group =
				vim.api.nvim_create_augroup("dotfiles_bufferline_visibility", { clear = true })

			local function update_bufferline_visibility()
				vim.opt.showtabline = vim.bo.filetype == "snacks_dashboard" and 0 or 2
			end

			local function schedule_update()
				vim.schedule(update_bufferline_visibility)
			end

			vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "FileType" }, {
				group = group,
				callback = schedule_update,
			})
			-- Snacks creates the dashboard from a scheduled startup callback. Run one
			-- scheduled update after UIEnter and after VeryLazy so either plugin wins
			-- without eagerly loading Bufferline or replacing LazyVim's config.
			vim.api.nvim_create_autocmd("UIEnter", {
				group = group,
				callback = schedule_update,
			})
			vim.api.nvim_create_autocmd("User", {
				group = group,
				pattern = "VeryLazy",
				callback = schedule_update,
			})
		end,
		opts = function(_, opts)
			opts.options = opts.options or {}
			opts.options.always_show_bufferline = true
		end,
	},
	{
		"folke/snacks.nvim",
		---@type snacks.Config
		keys = {
			{
				"<leader>fe",
				function()
					Snacks.explorer({ cwd = LazyVim.root.git() })
				end,
				desc = "Explorer Snacks (Git root)",
			},
		},
		opts = {
			-- Neoscroll is the sole smooth-scroll owner. Snacks' scroll animation
			-- otherwise competes for the same viewport updates and causes lag during
			-- rapid visual-mode movement.
			scroll = { enabled = false },
			picker = {
				sources = {
					files = { hidden = true, ignored = true },
					grep = { hidden = true },
					explorer = { hidden = true, ignored = true },
				},
			},
		},
	},

	-- change trouble config
	{
		"folke/trouble.nvim",
		cmd = "Trouble",
		keys = {
			{
				"<leader>qq",
				"<cmd>Trouble diagnostics toggle focus=true<cr>",
				desc = "Diagnostics (Trouble)",
			},
			{
				"<leader>qb",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "Buffer Diagnostics (Trouble)",
			},
			{
				"<leader>cs",
				"<cmd>Trouble symbols toggle focus=false<cr>",
				desc = "Symbols (Trouble)",
			},
			{
				"<leader>cL",
				"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
				desc = "LSP Definitions / references / ... (Trouble)",
			},
			{
				"<leader>qL",
				"<cmd>Trouble loclist toggle<cr>",
				desc = "Location List (Trouble)",
			},
			{
				"<leader>qQ",
				"<cmd>Trouble qflist toggle<cr>",
				desc = "Quickfix List (Trouble)",
			},
		},
	},

	{
		"nvim-telescope/telescope.nvim",
		optional = true,
		opts = {
			defaults = {
				layout_strategy = "horizontal",
				layout_config = { prompt_position = "top" },
				sorting_strategy = "ascending",
				winblend = 0,
			},
		},
	},

	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
	},
}

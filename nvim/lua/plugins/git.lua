return {
	{
		"NeogitOrg/neogit",
		cmd = "Neogit",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"sindrets/diffview.nvim",
			"folke/snacks.nvim",
		},
		keys = {
			{ "<leader>gg", "<cmd>Neogit kind=tab<cr>", desc = "Git status (Neogit)" },
			{
				"<leader>gs",
				function()
					require("neogit").open({ kind = "vsplit" })
					vim.schedule(function()
						for _, window in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
							if vim.api.nvim_win_is_valid(window) then
								local buffer = vim.api.nvim_win_get_buf(window)
								if
									vim.api.nvim_buf_is_valid(buffer)
									and vim.bo[buffer].filetype == "NeogitStatus"
								then
									vim.api.nvim_set_current_win(window)
									vim.cmd("wincmd L")
									vim.api.nvim_win_set_width(window, 42)
									break
								end
							end
						end
					end)
				end,
				desc = "Git status (compact right split)",
			},
			{ "<leader>gc", "<cmd>Neogit commit<cr>", desc = "Git commit" },
			{ "<leader>gl", "<cmd>Neogit log<cr>", desc = "Git log / graph" },
			{ "<leader>gb", "<cmd>Neogit branch<cr>", desc = "Git branches" },
			{ "<leader>gt", "<cmd>Neogit tag<cr>", desc = "Git tags" },
			{ "<leader>gr", "<cmd>Neogit rebase<cr>", desc = "Git rebase" },
		},
		opts = {
			kind = "tab",
			graph_style = "unicode",
			commit_order = "topo",
			disable_insert_on_commit = "auto",
			prompt_force_push = true,
			prompt_amend_commit = true,
			filewatcher = { enabled = true, interval = 1000 },
			commit_editor = {
				kind = "tab",
				show_staged_diff = true,
				staged_diff_split_kind = "vsplit",
				spell_check = true,
			},
			rebase_editor = { kind = "auto" },
			merge_editor = { kind = "auto" },
			status = { recent_commit_count = 5 },
			sections = {
				recent = { folded = false, hidden = false },
			},
			integrations = {
				diffview = true,
				snacks = true,
			},
		},
	},
	{
		"folke/snacks.nvim",
		keys = {
			{ "<leader>gs", false },
		},
	},
	{
		"sindrets/diffview.nvim",
		cmd = {
			"DiffviewOpen",
			"DiffviewClose",
			"DiffviewFileHistory",
			"DiffviewFocusFiles",
			"DiffviewToggleFiles",
		},
		keys = {
			{ "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Git working tree diff" },
			{ "<leader>gD", "<cmd>DiffviewOpen HEAD~1<cr>", desc = "Git previous commit diff" },
			{ "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "Git current file history" },
			{ "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "Git repository history" },
			{ "<leader>gm", "<cmd>DiffviewOpen<cr>", desc = "Git merge conflicts" },
		},
		opts = {
			enhanced_diff_hl = true,
			show_help_hints = true,
			watch_index = true,
			view = {
				default = { layout = "diff2_horizontal", winbar_info = true },
				merge_tool = {
					layout = "diff3_horizontal",
					disable_diagnostics = true,
					winbar_info = true,
				},
				file_history = { layout = "diff2_horizontal", winbar_info = true },
			},
		},
	},
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			current_line_blame = false,
			current_line_blame_opts = { delay = 400 },
		},
		keys = {
			{
				"<leader>ghs",
				function()
					require("gitsigns").stage_hunk()
				end,
				desc = "Git stage hunk",
			},
			{
				"<leader>ghr",
				function()
					require("gitsigns").reset_hunk()
				end,
				desc = "Git reset hunk",
			},
			{
				"<leader>ghs",
				function()
					require("gitsigns").stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end,
				mode = "x",
				desc = "Git stage selected lines",
			},
			{
				"<leader>ghr",
				function()
					require("gitsigns").reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end,
				mode = "x",
				desc = "Git reset selected lines",
			},
			{ "<leader>ghu", "<cmd>Gitsigns stage_hunk<cr>", desc = "Git toggle hunk stage" },
			{ "<leader>ghp", "<cmd>Gitsigns preview_hunk_inline<cr>", desc = "Git preview hunk" },
			{ "<leader>ghb", "<cmd>Gitsigns blame_line<cr>", desc = "Git blame line" },
			{
				"<leader>gB",
				"<cmd>Gitsigns toggle_current_line_blame<cr>",
				desc = "Git toggle line blame",
			},
		},
	},
}

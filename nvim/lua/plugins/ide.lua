vim.filetype.add({
	extension = {
		http = "http",
		rest = "http",
	},
})

local function restart_last_task()
	local overseer = require("overseer")
	local tasks = overseer.list_tasks()
	if vim.tbl_isempty(tasks) then
		LazyVim.warn("No task has been run in this session.", { title = "Overseer" })
		return
	end
	overseer.run_action(tasks[1], "restart")
end

return {
	{
		"stevearc/overseer.nvim",
		lazy = true,
		cmd = {
			"OverseerClose",
			"OverseerOpen",
			"OverseerRun",
			"OverseerTaskAction",
			"OverseerToggle",
		},
		keys = {
			{ "<leader>oo", "<cmd>OverseerRun<cr>", desc = "Run task" },
			{ "<leader>or", restart_last_task, desc = "Restart last task" },
			{ "<leader>ot", "<cmd>OverseerTaskAction<cr>", desc = "Task action" },
			{ "<leader>ow", "<cmd>OverseerToggle!<cr>", desc = "Task list" },
		},
		opts = {
			-- DAP is enabled only when nvim-dap itself loads.
			dap = false,
			task_list = {
				keymaps = {
					["<C-j>"] = false,
					["<C-k>"] = false,
				},
			},
			form = { win_opts = { winblend = 0 } },
			task_win = { win_opts = { winblend = 0 } },
		},
	},
	{
		"nvim-neotest/neotest",
		optional = true,
		dependencies = {
			"nvim-neotest/neotest-jest",
			"marilari88/neotest-vitest",
			"stevearc/overseer.nvim",
		},
		opts = function(_, opts)
			opts.adapters = opts.adapters or {}
			local runner = require("util.js_test_runner")
			local vitest = require("neotest-vitest")({
				filter_dir = function(name)
					return runner.filter_dir(name)
				end,
			})
			if not vitest._dotfiles_runner_gate then
				local vitest_is_test_file = vitest.is_test_file
				vitest.is_test_file = function(file_path)
					return runner.select(file_path) == "vitest" and vitest_is_test_file(file_path)
				end
				vitest._dotfiles_runner_gate = true
			end

			local jest = require("neotest-jest")({
				isTestFile = function(file_path)
					return runner.is_test_file(file_path)
				end,
			})
			if not jest._dotfiles_runner_gate then
				local jest_is_test_file = jest.is_test_file
				jest.is_test_file = function(file_path)
					return runner.select(file_path) == "jest" and jest_is_test_file(file_path)
				end
				jest._dotfiles_runner_gate = true
			end

			opts.adapters[#opts.adapters + 1] = vitest
			opts.adapters[#opts.adapters + 1] = jest
			opts.consumers = opts.consumers or {}
			opts.consumers.overseer = require("neotest.consumers.overseer")
		end,
	},
	{
		"mfussenegger/nvim-dap",
		optional = true,
		dependencies = { "stevearc/overseer.nvim" },
		opts = function(_, opts)
			require("overseer").enable_dap()
			-- Breakpoints must be restored before any debug configuration starts.
			-- Loading this here keeps empty startup clean while also covering the
			-- standard LazyVim DAP mappings, not only our breakpoint mappings.
			require("lazy").load({ plugins = { "persistent-breakpoints.nvim" } })
			return opts
		end,
	},
	{
		"Weissle/persistent-breakpoints.nvim",
		lazy = true,
		dependencies = { "mfussenegger/nvim-dap" },
		keys = {
			{
				"<leader>dB",
				function()
					require("persistent-breakpoints.api").set_conditional_breakpoint()
				end,
				desc = "Persistent breakpoint condition",
			},
			{
				"<leader>db",
				function()
					require("persistent-breakpoints.api").toggle_breakpoint()
				end,
				desc = "Toggle persistent breakpoint",
			},
			{
				"<leader>dL",
				function()
					require("persistent-breakpoints.api").set_log_point()
				end,
				desc = "Set persistent log point",
			},
			{
				"<leader>dX",
				function()
					require("persistent-breakpoints.api").clear_all_breakpoints()
				end,
				desc = "Clear persistent breakpoints",
			},
		},
		opts = {
			save_dir = vim.fn.stdpath("state") .. "/breakpoints",
			load_breakpoints_event = { "BufReadPost" },
		},
		config = function(_, opts)
			require("persistent-breakpoints").setup(opts)
			require("persistent-breakpoints.api").load_breakpoints()
		end,
	},
	{
		"ThePrimeagen/refactoring.nvim",
		lazy = true,
		dependencies = {
			{ "lewis6991/async.nvim", lazy = true },
		},
		keys = {
			{
				"<leader>rs",
				function()
					return require("refactoring").select_refactor()
				end,
				mode = { "n", "x" },
				desc = "Select refactor",
			},
			{
				"<leader>ri",
				function()
					return require("refactoring").inline_var()
				end,
				mode = { "n", "x" },
				expr = true,
				desc = "Inline variable",
			},
			{
				"<leader>rI",
				function()
					return require("refactoring").inline_func()
				end,
				mode = { "n", "x" },
				expr = true,
				desc = "Inline function",
			},
			{
				"<leader>rf",
				function()
					return require("refactoring").extract_func()
				end,
				mode = { "n", "x" },
				expr = true,
				desc = "Extract function",
			},
			{
				"<leader>rF",
				function()
					return require("refactoring").extract_func_to_file()
				end,
				mode = { "n", "x" },
				expr = true,
				desc = "Extract function to file",
			},
			{
				"<leader>rx",
				function()
					return require("refactoring").extract_var()
				end,
				mode = { "n", "x" },
				expr = true,
				desc = "Extract variable",
			},
		},
		opts = {},
	},
	{
		"mistweaverco/kulala.nvim",
		lazy = true,
		-- Kulala ships VimLeavePre/SessionLoadPost package events. They are
		-- unnecessary with session restore disabled and would turn an opt-in
		-- REST client into an exit-time startup cost.
		event = function()
			return {}
		end,
		ft = { "http" },
		keys = {
			{
				"<leader>Rb",
				function()
					require("kulala").scratchpad()
				end,
				desc = "REST scratchpad",
			},
			{
				"<leader>Ra",
				function()
					require("kulala").run_all()
				end,
				mode = { "n", "x" },
				ft = "http",
				desc = "Run all REST requests",
			},
			{
				"<leader>Rc",
				function()
					require("kulala").copy()
				end,
				ft = "http",
				desc = "Copy request as cURL",
			},
			{
				"<leader>Re",
				function()
					require("kulala").set_selected_env()
				end,
				ft = "http",
				desc = "Select REST environment",
			},
			{
				"<leader>Ri",
				function()
					require("kulala").inspect()
				end,
				ft = "http",
				desc = "Inspect REST request",
			},
			{
				"<leader>Rn",
				function()
					require("kulala").jump_next()
				end,
				ft = "http",
				desc = "Next REST request",
			},
			{
				"<leader>Rp",
				function()
					require("kulala").jump_prev()
				end,
				ft = "http",
				desc = "Previous REST request",
			},
			{
				"<leader>Rr",
				function()
					require("kulala").replay()
				end,
				ft = "http",
				desc = "Replay REST request",
			},
			{
				"<leader>Rs",
				function()
					require("kulala").run()
				end,
				mode = { "n", "x" },
				ft = "http",
				desc = "Send REST request",
			},
			{
				"<leader>Rt",
				function()
					require("kulala").toggle_view()
				end,
				ft = "http",
				desc = "Toggle REST body / headers",
			},
		},
		opts = {
			session = { restore = false },
			ui = {
				display_mode = "split",
				split_direction = "right",
			},
		},
	},
	{
		"andythigpen/nvim-coverage",
		lazy = true,
		dependencies = { "nvim-lua/plenary.nvim" },
		cmd = {
			"Coverage",
			"CoverageClear",
			"CoverageHide",
			"CoverageLoad",
			"CoverageLoadLcov",
			"CoverageShow",
			"CoverageSummary",
			"CoverageToggle",
		},
		keys = {
			{ "<leader>tc", "<cmd>Coverage<cr>", desc = "Load and show coverage" },
			{ "<leader>tC", "<cmd>CoverageSummary<cr>", desc = "Coverage summary" },
		},
		opts = {
			auto_reload = true,
		},
	},
	{
		"folke/which-key.nvim",
		optional = true,
		opts = {
			spec = {
				{ "<leader>o", group = "tasks" },
				{ "<leader>r", group = "refactor" },
				{ "<leader>R", group = "REST" },
			},
		},
	},
}

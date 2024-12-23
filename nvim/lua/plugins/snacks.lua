---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
local progress = vim.defaulttable()
vim.api.nvim_create_autocmd("LspProgress", {
	---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
		if not client or type(value) ~= "table" then
			return
		end
		local p = progress[client.id]

		for i = 1, #p + 1 do
			if i == #p + 1 or p[i].token == ev.data.params.token then
				p[i] = {
					token = ev.data.params.token,
					msg = ("[%3d%%] %s%s"):format(
						value.kind == "end" and 100 or value.percentage or 100,
						value.title or "",
						value.message and (" **%s**"):format(value.message) or ""
					),
					done = value.kind == "end",
				}
				break
			end
		end

		local msg = {} ---@type string[]
		progress[client.id] = vim.tbl_filter(function(v)
			return table.insert(msg, v.msg) or not v.done
		end, p)

		local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
		vim.notify(table.concat(msg, "\n"), "info", {
			id = "lsp_progress",
			title = client.name,
			opts = function(notif)
				notif.icon = #progress[client.id] == 0 and " "
					or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
			end,
		})
	end,
})

local snackKeyMaps = {
	-- BUFFERS
	{
		"<leader>.",
		function()
			Snacks.scratch()
		end,
		desc = "Toggle Scratch Buffer",
	},
	{
		"<leader>S",
		function()
			Snacks.scratch.select()
		end,
		desc = "Select Scratch Buffer",
	},
	{
		"<leader>bd",
		function()
			Snacks.bufdelete()
		end,
		desc = "Delete Buffer",
	},
	{
		"<leader>bx",
		function()
			Snacks.bufdelete()
		end,
		desc = "Delete Buffer except thisd",
	},
	{
		"<leader>ba",
		function()
			Snacks.bufdelete()
		end,
		desc = "Delete All Buffer",
	},

	{
		"<leader>cR",
		function()
			Snacks.rename.rename_file()
		end,
		desc = "Rename File",
	},

	-- GIT
	{
		"<leader>gB",
		function()
			Snacks.gitbrowse()
		end,
		desc = "Git Browse",
		mode = { "n", "v" },
	},
	{
		"<leader>gb",
		function()
			Snacks.git.blame_line()
		end,
		desc = "Git Blame Line",
	},
	{
		"<leader>gf",
		function()
			Snacks.lazygit.log_file()
		end,
		desc = "Lazygit Current File History",
	},
	{
		"<leader>gg",
		function()
			Snacks.lazygit()
		end,
		desc = "Lazygit",
	},
	{
		"<leader>gl",
		function()
			Snacks.lazygit.log()
		end,
		desc = "Lazygit Log (cwd)",
	},

	-- TERMINAL
	{
		"<c-/>",
		function()
			Snacks.terminal()
		end,
		desc = "Toggle Terminal",
	},

	-- NOTIFICATIONS
	{
		"<leader>n",
		function()
			Snacks.notifier.show_history()
		end,
		desc = "Notification History",
	},
	{
		"<leader>un",
		function()
			Snacks.notifier.hide()
		end,
		desc = "Dismiss All Notifications",
	},

	-- UI
	{
		"<leader>z",
		function()
			Snacks.zen()
		end,
		desc = "Toggle Zen Mode",
	},
	{
		"<leader>Z",
		function()
			Snacks.zen.zoom()
		end,
		desc = "Toggle Zoom",
	},
	{
		"<c-_>",
		function()
			Snacks.terminal()
		end,
		desc = "which_key_ignore",
	},
	{
		"]]",
		function()
			Snacks.words.jump(vim.v.count1)
		end,
		desc = "Next Reference",
		mode = { "n", "t" },
	},
	{
		"[[",
		function()
			Snacks.words.jump(-vim.v.count1)
		end,
		desc = "Prev Reference",
		mode = { "n", "t" },
	},

	{
		"<leader>N",
		desc = "Neovim News",
		function()
			Snacks.win({
				file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
				width = 0.6,
				height = 0.6,
				wo = {
					spell = false,
					wrap = false,
					signcolumn = "yes",
					statuscolumn = " ",
					conceallevel = 3,
				},
			})
		end,
	},
}

local bigfile = {
	enabled = true,
	notify = true, -- show notification when big file detected
	size = 5.5 * 1024 * 1024, -- 5.5MB
	-- Enable or disable features when big file detected
	---@param ctx {buf: number, ft:string}
	setup = function(ctx)
		vim.cmd([[NoMatchParen]])
		Snacks.util.wo(0, { foldmethod = "manual", statuscolumn = "", conceallevel = 0 })
		vim.b.minianimate_disable = true
		vim.schedule(function()
			vim.bo[ctx.buf].syntax = ctx.ft
		end)
	end,
}

local dashboard = {

	enabled = true,
	theme = "hyper",
	config = {
		week_header = {
			enable = true,
		},
		shortcut = {
			{ desc = "󰊳 Update", group = "@property", action = "Lazy update", key = "u" },
			{
				icon = " ",
				icon_hl = "@variable",
				desc = "Files",
				group = "Label",
				action = "Telescope find_files",
				key = "f",
			},
			{
				desc = " Menu",
				group = "DiagnosticHint",
				action = "Neotree left toggle reveal",
				key = "e",
			},
		},
	},
}

---@class snacks.indent.Config
---@field enabled? boolean
local indent = {
	enabled = true, -- enable indent guides
	indent = {
		priority = 1,
		enabled = true, -- enable indent guides
		char = "┊",
		only_scope = false, -- only show indent guides of the scope
		only_current = false, -- only show indent guides in the current window
		hl = "SnacksIndent", ---@type string|string[] hl groups for indent guides
	},
	-- animate scopes. Enabled by default for Neovim >= 0.10
	-- Works on older versions but has to trigger redraws during animation.
	---@class snacks.indent.animate: snacks.animate.Config
	---@field enabled? boolean
	--- * out: animate outwards from the cursor
	--- * up: animate upwards from the cursor
	--- * down: animate downwards from the cursor
	--- * up_down: animate up or down based on the cursor position
	---@field style? "out"|"up_down"|"down"|"up"
	animate = {
		enabled = vim.fn.has("nvim-0.10") == 1,
		style = "out",
		easing = "linear",
		duration = {
			step = 20, -- ms per step
			total = 500, -- maximum duration
		},
	},
	---@class snacks.indent.Scope.Config: snacks.scope.Config
	scope = {
		enabled = true, -- enable highlighting the current scope
		priority = 200,
		char = "│",
		underline = false, -- underline the start of the scope
		only_current = false, -- only show scope in the current window
		hl = "SnacksIndentScope", ---@type string|string[] hl group for scopes
	},
	chunk = {
		-- when enabled, scopes will be rendered as chunks, except for the
		-- top-level scope which will be rendered as a scope.
		enabled = false,
		-- only show chunk scopes in the current window
		only_current = false,
		priority = 200,
		hl = "SnacksIndentChunk", ---@type string|string[] hl group for chunk scopes
		char = {
			corner_top = "┌",
			corner_bottom = "└",
			-- corner_top = "╭",
			-- corner_bottom = "╰",
			horizontal = "─",
			vertical = "│",
			arrow = ">",
		},
	},
	blank = {
		char = " ",
		-- char = "·",
		hl = "SnacksIndentBlank", ---@type string|string[] hl group for blank spaces
	},
	-- filter for buffers to enable indent guides
	filter = function(buf)
		return vim.g.snacks_indent ~= false and vim.b[buf].snacks_indent ~= false and vim.bo[buf].buftype == ""
	end,
}

local terminal = {
	enabled = true,
	direction = "horizontal",
	size = 10,
	open_mapping = [[<c-\>]],
}

local scroll = {
	enabled = true,
	animate = {
		duration = { step = 15, total = 250 },
		easing = "linear",
	},
	spamming = 10, -- threshold for spamming detection
	filter = function(buf)
		return vim.g.snacks_scroll ~= false and vim.b[buf].snacks_scroll ~= false and vim.bo[buf].buftype ~= "terminal"
	end,
}

local statuscolumn = {
	enabled = true,
	left = { "mark", "sign" }, -- priority of signs on the left (high to low)
	right = { "fold", "git" }, -- priority of signs on the right (high to low)
	folds = {
		open = false, -- show open fold icons
		git_hl = false, -- use Git Signs hl for fold icons
	},
	git = {
		-- patterns to match Git signs
		patterns = { "GitSign", "MiniDiffSign" },
	},
	refresh = 50, -- refresh at most every 50ms
}

local scope = {
	enabled = true,
	min_size = 2,
	max_size = nil,
	cursor = true, -- when true, the column of the cursor is used to determine the scope
	edge = true, -- include the edge of the scope (typically the line above and below with smaller indent)
	siblings = false, -- expand single line scopes with single line siblings
	filter = function(buf)
		return vim.bo[buf].buftype == ""
	end,
	debounce = 30,
}

local dim = {
	enabled = true,
	---@type snacks.scope.Config
	scope = {
		min_size = 5,
		max_size = 20,
		siblings = true,
	},
	---@type snacks.animate.Config|{enabled?: boolean}
	animate = {
		enabled = vim.fn.has("nvim-0.10") == 1,
		easing = "outQuad",
		duration = {
			step = 20, -- ms per step
			total = 300, -- maximum duration
		},
	},
	-- what buffers to dim
	filter = function(buf)
		return vim.g.snacks_dim ~= false and vim.b[buf].snacks_dim ~= false and vim.bo[buf].buftype == ""
	end,
}

local toggle = {
	enabled = true,
	map = vim.keymap.set, -- keymap.set function to use
	which_key = true, -- integrate with which-key to show enabled/disabled icons and colors
	notify = true, -- show a notification when toggling
	icon = {
		enabled = " ",
		disabled = " ",
	},
	color = {
		enabled = "green",
		disabled = "yellow",
	},
}

local words = {
	enabled = true,
	debounce = 200, -- time in ms to wait before updating
	notify_jump = false, -- show a notification when jumping
	notify_end = true, -- show a notification when reaching the end
	foldopen = true, -- open folds after jumping
	jumplist = true, -- set jump point before jumping
	modes = { "n", "i", "c" }, -- modes to show references
}

local lazygit = {
	enabled = true,
	configure = true,
	config = {
		os = { editPreset = "nvim-remote" },
		gui = {
			nerdFontsVersion = "3",
		},
	},
	theme_path = vim.fs.normalize(vim.fn.stdpath("cache") .. "/lazygit-theme.yml"),
	theme = {
		[241] = { fg = "Special" },
		activeBorderColor = { fg = "MatchParen", bold = true },
		cherryPickedCommitBgColor = { fg = "Identifier" },
		cherryPickedCommitFgColor = { fg = "Function" },
		defaultFgColor = { fg = "Normal" },
		inactiveBorderColor = { fg = "FloatBorder" },
		optionsTextColor = { fg = "Function" },
		searchingActiveBorderColor = { fg = "MatchParen", bold = true },
		selectedLineBgColor = { bg = "Visual" }, -- set to `default` to have no background colour
		unstagedChangesColor = { fg = "DiagnosticError" },
	},
	win = {
		style = "lazygit",
	},
}

return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,

	---@type snacks.Config
	opts = {
		bigfile = bigfile,
		dashboard = dashboard,
		indent = indent,
		terminal = terminal,
		scroll = scroll,
		statuscolumn = statuscolumn,
		words = words,
		scope = scope,
		dim = dim,
		lazygit = lazygit,
		toggle = toggle,
		quickfile = { enabled = true },
		win = { enabled = true },
		notifier = {
			enabled = true,
			timeout = 3000,
		},

		input = {
			enabled = true,
			icon = " ",
			icon_hl = "SnacksInputIcon",
			icon_pos = "left",
			prompt_pos = "title",
			win = { style = "input" },
			expand = true,
		},

		styles = {
			terminal = {
				bo = {
					filetype = "snacks_terminal",
				},
				wo = {},
				keys = {
					q = "hide",
					gf = function(self)
						local f = vim.fn.findfile(vim.fn.expand("<cfile>"), "**")
						if f == "" then
							Snacks.notify.warn("No file under cursor")
						else
							self:hide()
							vim.schedule(function()
								vim.cmd("e " .. f)
							end)
						end
					end,
					term_normal = {
						"<esc>",
						function(self)
							self.esc_timer = self.esc_timer or (vim.uv or vim.loop).new_timer()
							if self.esc_timer:is_active() then
								self.esc_timer:stop()
								vim.cmd("stopinsert")
							else
								self.esc_timer:start(200, 0, function() end)
								return "<esc>"
							end
						end,
						mode = "t",
						expr = true,
						desc = "Double escape to normal mode",
					},
				},
			},
			input = {
				backdrop = false,
				position = "float",
				border = "rounded",
				title_pos = "center",
				height = 1,
				width = 60,
				relative = "editor",
				noautocmd = true,
				row = 2,
				-- relative = "cursor",
				-- row = -3,
				-- col = 0,
				wo = {
					winhighlight = "NormalFloat:SnacksInputNormal,FloatBorder:SnacksInputBorder,FloatTitle:SnacksInputTitle",
					cursorline = false,
				},
				bo = {
					filetype = "snacks_input",
					buftype = "prompt",
				},
				--- buffer local variables
				b = {
					completion = false, -- disable blink completions in input
				},
				keys = {
					n_esc = { "<esc>", { "cmp_close", "cancel" }, mode = "n" },
					i_esc = { "<esc>", { "cmp_close", "stopinsert" }, mode = "i" },
					i_cr = { "<cr>", { "cmp_accept", "confirm" }, mode = "i" },
					i_tab = { "<tab>", { "cmp_select_next", "cmp" }, mode = "i" },
					q = "cancel",
				},
			},
			notification = {
				-- wo = { wrap = true } -- Wrap notifications
			},
		},
	},
	keys = snackKeyMaps,
	init = function()
		vim.api.nvim_create_autocmd("User", {
			pattern = "VeryLazy",
			callback = function()
				-- Setup some globals for debugging (lazy-loaded)
				_G.dd = function(...)
					Snacks.debug.inspect(...)
				end
				_G.bt = function()
					Snacks.debug.backtrace()
				end
				vim.print = _G.dd -- Override print to use snacks for `:=` command

				Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
				-- Toggle the profiler
				Snacks.toggle.profiler():map("<leader>pp")
				-- Toggle the profiler highlights
				Snacks.toggle.profiler_highlights():map("<leader>ph")
				Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
				Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
				Snacks.toggle.diagnostics():map("<leader>ud")
				Snacks.toggle.line_number():map("<leader>ul")
				Snacks.toggle
					.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
					:map("<leader>uc")
				Snacks.toggle.treesitter():map("<leader>uT")
				Snacks.toggle
					.option("background", { off = "light", on = "dark", name = "Dark Background" })
					:map("<leader>ub")
				Snacks.toggle.inlay_hints():map("<leader>uh")
				Snacks.toggle.indent():map("<leader>ug")
				Snacks.toggle.dim():map("<leader>uD")
			end,
		})
	end,
}

-- IDE chrome: project header, breadcrumbs, dense statusline and the code
-- action indicator. Everything here is presentation only; behaviour stays with
-- the owning plugin (Snacks explorer, Neogit, Trouble, Overseer, LSP).

local function project_root()
	local ok, root = pcall(LazyVim.root.git)
	if not ok or not root or root == "" then
		root = vim.uv.cwd() or ""
	end
	return root
end

local function project_name()
	local name = vim.fs.basename(project_root())
	return name ~= "" and name or "nvim"
end

--- The project header names the repository. The statusline says the same
--- thing, and appends the sub-root when the language server resolved a nested
--- project, so a monorepo reads as `repo/package` instead of just `package`.
local function project_label()
	local git = project_root()
	local name = project_name()
	local ok, root = pcall(LazyVim.root.get, { normalize = true })
	if ok and root and git ~= "" and root ~= git and root:find(git .. "/", 1, true) == 1 then
		name = name .. root:sub(#git + 1)
	end
	return "󱉭 " .. name
end

--- Filetypes that must never receive breadcrumbs or a lualine buffer section.
local chrome_free = {
	"snacks_dashboard",
	"snacks_layout_box",
	"snacks_picker_input",
	"snacks_picker_list",
	"snacks_picker_preview",
	"snacks_terminal",
	"snacks_notif",
	"trouble",
	"Trouble",
	"lazy",
	"mason",
	"help",
	"qf",
	"neotest-summary",
	"neotest-output-panel",
	"OverseerList",
	"NeogitStatus",
	"NeogitPopup",
	"NeogitCommitView",
	"DiffviewFiles",
	"DiffviewFileHistory",
	"dbui",
	"dbout",
	"gitcommit",
	"gitrebase",
}

--- Zed-style clickable panel buttons for the left edge of the statusline.
--- Each button is its own lualine component so it can own an `on_click`.
local panel_buttons = {
	{
		icon = "󰙅",
		name = "Explorer",
		open = function()
			Snacks.explorer({ cwd = LazyVim.root.git() })
		end,
	},
	{
		icon = "󰊢",
		name = "Git",
		open = function()
			vim.cmd("Neogit kind=vsplit")
		end,
	},
	{
		icon = "󱖫",
		name = "Problems",
		open = function()
			vim.cmd("Trouble diagnostics toggle focus=true")
		end,
	},
	{
		icon = "󰙨",
		name = "Tests",
		open = function()
			require("neotest").summary.toggle()
		end,
	},
	{
		icon = "󰐊",
		name = "Tasks",
		open = function()
			vim.cmd("OverseerToggle!")
		end,
	},
	{
		icon = "󰆍",
		name = "Terminal",
		open = function()
			Snacks.terminal(nil, { cwd = LazyVim.root.get() })
		end,
	},
}

local function panel_component(panel)
	return {
		function()
			return panel.icon
		end,
		-- Nerd Font panel glyphs are wide; one cell of padding on each side keeps
		-- them from visually merging into a single blob in the statusline.
		padding = { left = 1, right = 1 },
		separator = "",
		on_click = function()
			vim.schedule(function()
				local ok, err = pcall(panel.open)
				if not ok then
					LazyVim.warn(tostring(err), { title = panel.name })
				end
			end)
		end,
		color = function()
			return { fg = Snacks.util.color("Comment") }
		end,
	}
end

--- Language servers attached to the current buffer.
local function lsp_clients()
	local names = {}
	for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
		if client.name ~= "null-ls" and client.name ~= "copilot" then
			names[#names + 1] = client.name
		end
	end
	if #names == 0 then
		return ""
	end
	table.sort(names)
	return "󰒋 " .. table.concat(names, " ")
end

--- Formatters Conform would run on save. Cached per filetype: the answer only
--- depends on the Conform configuration, not on buffer contents.
local formatter_cache = {}

local function formatters()
	if not package.loaded["conform"] then
		return ""
	end
	local ft = vim.bo.filetype
	local cached = formatter_cache[ft]
	if cached == nil then
		local ok, conform = pcall(require, "conform")
		local names = {}
		if ok then
			for _, formatter in ipairs(conform.list_formatters_to_run(0) or {}) do
				if formatter.available then
					names[#names + 1] = formatter.name
				end
			end
		end
		cached = #names > 0 and ("󰉼 " .. table.concat(names, " ")) or ""
		formatter_cache[ft] = cached
	end
	return cached
end

--- Aggregated Overseer task state, mirroring a JetBrains services widget.
local function tasks()
	if not package.loaded["overseer"] then
		return ""
	end
	local ok, overseer = pcall(require, "overseer")
	if not ok then
		return ""
	end
	local status = require("overseer.constants").STATUS
	local icons = {
		[status.RUNNING] = "󰑮",
		[status.SUCCESS] = "󰄬",
		[status.FAILURE] = "󰅖",
		[status.CANCELED] = "󰜺",
	}
	local counts = {}
	for _, task in ipairs(overseer.list_tasks({ unique = true })) do
		counts[task.status] = (counts[task.status] or 0) + 1
	end
	local parts = {}
	for _, key in ipairs({ status.RUNNING, status.FAILURE, status.SUCCESS, status.CANCELED }) do
		if counts[key] then
			parts[#parts + 1] = icons[key] .. " " .. counts[key]
		end
	end
	return table.concat(parts, " ")
end

--- Indentation contract of the current buffer, as shown by Zed and WebStorm.
local function indentation()
	local width = vim.bo.shiftwidth
	if width == 0 then
		width = vim.bo.tabstop
	end
	return (vim.bo.expandtab and "Spaces: " or "Tabs: ") .. width
end

--- Encoding and line ending, printed only when they differ from the default.
local function file_encoding()
	local parts = {}
	local encoding = vim.bo.fileencoding ~= "" and vim.bo.fileencoding or vim.o.encoding
	if encoding ~= "utf-8" then
		parts[#parts + 1] = encoding:upper()
	end
	local endings = { dos = "CRLF", mac = "CR" }
	if endings[vim.bo.fileformat] then
		parts[#parts + 1] = endings[vim.bo.fileformat]
	end
	return table.concat(parts, " ")
end

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
			opts.options.show_buffer_close_icons = true
			opts.options.separator_style = "thin"

			-- The explorer sidebar becomes the project header: the tab row above it
			-- carries repository name and checked-out branch, like an IDE title bar.
			opts.options.offsets = {
				{
					filetype = "snacks_layout_box",
					text = function()
						local head = vim.g.gitsigns_head
						local label = "  " .. project_name()
						if head and head ~= "" then
							label = label .. "    " .. head
						end
						return label
					end,
					highlight = "Directory",
					text_align = "left",
					separator = true,
				},
				{
					filetype = "neo-tree",
					text = project_name,
					highlight = "Directory",
					text_align = "left",
					separator = true,
				},
			}
			return opts
		end,
	},

	-- Breadcrumbs. Interactive winbar built from the file path plus LSP or
	-- Tree-sitter symbols; this is the single owner of `winbar`.
	{
		"Bekaboo/dropbar.nvim",
		event = "LazyFile",
		keys = {
			{
				"<leader>cb",
				function()
					require("dropbar.api").pick()
				end,
				desc = "Breadcrumb picker (dropbar)",
			},
		},
		opts = function()
			local sources = require("dropbar.sources")
			local utils = require("dropbar.utils")
			return {
				bar = {
					enable = function(buf, win, _)
						if
							not vim.api.nvim_buf_is_valid(buf)
							or not vim.api.nvim_win_is_valid(win)
							or vim.fn.win_gettype(win) ~= ""
							or vim.wo[win].diff
						then
							return false
						end
						local name = vim.api.nvim_buf_get_name(buf)
						if name == "" or vim.bo[buf].buftype ~= "" then
							return false
						end
						-- Symbol extraction on a generated or vendored file is not
						-- worth a winbar; keep dropbar's own size guard.
						local stat = vim.uv.fs_stat(name)
						if stat and stat.size > 1024 * 1024 then
							return false
						end
						return not vim.tbl_contains(chrome_free, vim.bo[buf].filetype)
					end,
					sources = function(buf, _)
						if vim.bo[buf].filetype == "markdown" then
							return { sources.path, sources.markdown }
						end
						return {
							sources.path,
							utils.source.fallback({ sources.lsp, sources.treesitter }),
						}
					end,
					padding = { left = 1, right = 1 },
				},
				icons = {
					ui = { bar = { separator = "  ", extends = "…" } },
				},
				menu = {
					preview = true,
					quick_navigation = true,
				},
			}
		end,
	},

	-- Code action indicator: the IDE "lightbulb" that marks a line where the
	-- language server offers a refactor or quick fix.
	{
		"kosayoda/nvim-lightbulb",
		event = "LspAttach",
		opts = {
			autocmd = { enabled = true, updatetime = 200 },
			sign = { enabled = false },
			virtual_text = {
				enabled = true,
				text = "󰌵",
				pos = "eol",
				hl = "DiagnosticSignHint",
				hl_mode = "combine",
			},
			ignore = {
				ft = chrome_free,
				actions_without_kind = false,
			},
		},
		config = function(_, opts)
			require("nvim-lightbulb").setup(opts)
			Snacks.toggle({
				name = "Code Action Hint",
				get = function()
					return vim.g.dotfiles_lightbulb ~= false
				end,
				set = function(enabled)
					vim.g.dotfiles_lightbulb = enabled
					require("nvim-lightbulb").setup(vim.tbl_deep_extend("force", opts, {
						autocmd = { enabled = enabled },
						virtual_text = { enabled = enabled },
					}))
					if not enabled then
						require("nvim-lightbulb").clear_lightbulb()
					end
				end,
			}):map("<leader>uB")
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
			-- Toasts are the visible end of the noice message pipeline. `fancy`
			-- draws a titled, bordered card per notification.
			notifier = {
				style = "fancy",
				top_down = true,
				timeout = 4000,
				width = { min = 40, max = 0.35 },
				height = { min = 1, max = 0.5 },
				margin = { top = 0, right = 1, bottom = 0 },
				padding = true,
				icons = {
					error = " ",
					warn = " ",
					info = " ",
					debug = " ",
					trace = " ",
				},
			},
			picker = {
				sources = {
					files = { hidden = true, ignored = true },
					grep = { hidden = true },
					explorer = {
						hidden = true,
						ignored = true,
						-- Roll the git status and the worst diagnostic of a closed
						-- directory up onto its row. That is the JetBrains "project
						-- view" affordance the plain file list lacks; the rest of the
						-- explorer keeps the tested Snacks defaults, including the
						-- sidebar layout without an in-editor preview.
						diagnostics_open = true,
						git_status_open = true,
					},
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
				"<cmd>Trouble symbols toggle focus=false win.position=right<cr>",
				desc = "Symbols outline (Trouble)",
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
		opts = function(_, opts)
			local icons = LazyVim.config.icons

			opts.options = opts.options or {}
			opts.options.globalstatus = true
			opts.options.disabled_filetypes = { statusline = { "snacks_dashboard" } }
			opts.options.component_separators = { left = "", right = "" }
			opts.options.section_separators = { left = "", right = "" }

			-- LazyVim's `root_dir` prints the language-server root, and only when
			-- it differs from the cwd, which contradicts the repository name in
			-- the project header. Replace it with a label that always names the
			-- repository. It is matched by shape rather than by index, so a
			-- LazyVim layout change degrades to "no project name" instead of to a
			-- wrong one.
			for index, component in ipairs(opts.sections.lualine_c) do
				if
					type(component) == "table"
					and type(component[1]) == "function"
					and type(component.cond) == "function"
					and component.color ~= nil
				then
					opts.sections.lualine_c[index] = {
						project_label,
						color = function()
							return { fg = Snacks.util.color("Special") }
						end,
					}
					break
				end
			end

			-- Left edge: clickable panel buttons, then the project and the path
			-- context that LazyVim already assembles.
			for index = #panel_buttons, 1, -1 do
				table.insert(opts.sections.lualine_c, 1, panel_component(panel_buttons[index]))
			end

			opts.sections.lualine_b = {
				{ "branch", icon = "" },
				{
					"diff",
					symbols = {
						added = icons.git.added,
						modified = icons.git.modified,
						removed = icons.git.removed,
					},
					source = function()
						local gitsigns = vim.b.gitsigns_status_dict
						if gitsigns then
							return {
								added = gitsigns.added,
								modified = gitsigns.changed,
								removed = gitsigns.removed,
							}
						end
					end,
				},
			}

			-- LazyVim keeps `diff` in lualine_x; it now lives next to the branch.
			opts.sections.lualine_x = vim.tbl_filter(function(component)
				return component[1] ~= "diff"
			end, opts.sections.lualine_x)

			vim.list_extend(opts.sections.lualine_x, {
				{
					tasks,
					cond = function()
						return package.loaded["overseer"] ~= nil and tasks() ~= ""
					end,
					color = function()
						return { fg = Snacks.util.color("Function") }
					end,
				},
				{
					formatters,
					cond = function()
						return package.loaded["conform"] ~= nil
					end,
					color = function()
						return { fg = Snacks.util.color("Comment") }
					end,
				},
				{
					lsp_clients,
					color = function()
						return { fg = Snacks.util.color("Comment") }
					end,
				},
			})

			opts.sections.lualine_y = {
				{ indentation, padding = { left = 1, right = 1 } },
				{ file_encoding, padding = { left = 0, right = 1 } },
				{ "filetype", icon_only = false, padding = { left = 0, right = 1 } },
			}

			opts.sections.lualine_z = {
				{ "progress", separator = " ", padding = { left = 1, right = 0 } },
				{ "location", padding = { left = 0, right = 1 } },
				{
					function()
						return " " .. os.date("%R")
					end,
					padding = { left = 0, right = 1 },
				},
			}

			opts.extensions =
				{ "lazy", "fzf", "quickfix", "man", "trouble", "overseer", "nvim-dap-ui" }

			return opts
		end,
	},

	-- Messages, cmdline and notifications. Noice owns the message UI; the
	-- Snacks notifier renders the toasts noice routes to `vim.notify`.
	{
		"folke/noice.nvim",
		opts = function(_, opts)
			opts.presets = vim.tbl_extend("force", opts.presets or {}, {
				-- Hover and signature help get the same rounded frame as the rest
				-- of the floating UI.
				lsp_doc_border = true,
				-- The inc-rename extra is enabled, so `<leader>cr` can preview the
				-- rename live in the cmdline input.
				inc_rename = true,
			})

			opts.lsp = vim.tbl_deep_extend("force", opts.lsp or {}, {
				hover = { silent = true },
				signature = { auto_open = { enabled = true } },
				-- Server progress belongs in one place: a small bottom-right
				-- spinner, not a stack of toasts.
				progress = { enabled = true, view = "mini" },
			})

			opts.notify = { enabled = true, view = "notify" }

			-- Routine editor chatter goes to the unobtrusive `mini` view; pure
			-- noise is dropped. Anything not listed still gets a real toast.
			opts.routes = opts.routes or {}
			vim.list_extend(opts.routes, {
				{
					filter = {
						event = "msg_show",
						any = {
							{ find = "written" },
							{ find = "%d+ changes?; before #%d+" },
							{ find = "%d+ changes?; after #%d+" },
							{ find = "%d+ fewer lines" },
							{ find = "%d+ more lines?" },
							{ find = "%d+ lines? yanked" },
							{ find = "^E486:" },
							{ find = "search hit BOTTOM" },
							{ find = "search hit TOP" },
						},
					},
					view = "mini",
				},
				{ filter = { event = "msg_show", kind = "search_count" }, opts = { skip = true } },
				{
					filter = { event = "notify", find = "No information available" },
					opts = { skip = true },
				},
				{
					filter = { event = "lsp", kind = "progress", find = "Diagnosing" },
					opts = { skip = true },
				},
			})

			opts.views = vim.tbl_deep_extend("force", opts.views or {}, {
				cmdline_popup = {
					border = { style = "rounded" },
					win_options = { winblend = 0 },
				},
				confirm = { border = { style = "rounded" } },
				hover = { border = { style = "rounded" } },
				mini = { win_options = { winblend = 0 } },
				popupmenu = { border = { style = "rounded" } },
			})

			return opts
		end,
	},

	-- Docked panels. Edgy turns the ad-hoc splits that Trouble, Overseer,
	-- Neogit, Neotest, Dadbod and the Snacks explorer open into fixed edges,
	-- so a panel always appears in the same place at the same size.
	{
		"folke/edgy.nvim",
		optional = true,
		opts = function(_, opts)
			-- Edge animation redraws on a timer and cannot move the floats that
			-- Snacks anchors inside the explorer box, so the sidebar would tear
			-- while opening. Placement is instant instead.
			opts.animate = { enabled = false }

			opts.options = {
				left = { size = 40 },
				right = { size = 46 },
				bottom = { size = 14 },
				top = { size = 10 },
			}

			-- Project view. The explorer's input and list are floats anchored to
			-- one real split whose filetype is `snacks_layout_box`; that split is
			-- what edgy docks. Its edgy winbar is suppressed because the picker
			-- draws its own title and the anchored floats are positioned against
			-- the full box height.
			table.insert(opts.left, 1, {
				ft = "snacks_layout_box",
				title = "Project",
				size = { width = 40 },
				wo = { winbar = false },
				open = function()
					Snacks.explorer({ cwd = LazyVim.root.git() })
				end,
				filter = function(_buf, win)
					return vim.w[win].snacks_win ~= nil
						and vim.w[win].snacks_win.relative == "editor"
						and vim.w[win].snacks_win.position == "left"
				end,
			})

			vim.list_extend(opts.right, {
				{
					ft = "NeogitStatus",
					title = "Git",
					size = { width = 46 },
					-- Only the `<leader>gs` panel is docked. `<leader>gg` opens
					-- Neogit as a full tab page and must keep the whole width.
					filter = function(_buf, win)
						return vim.w[win].dotfiles_git_panel == true
					end,
				},
				{ ft = "dbui", title = "Databases", size = { width = 42 } },
			})

			vim.list_extend(opts.bottom, {
				{ ft = "OverseerList", title = "Tasks", size = { height = 0.3 } },
				{ ft = "OverseerOutput", title = "Task output", size = { height = 0.3 } },
				{ ft = "dbout", title = "Query result", size = { height = 0.3 } },
			})

			return opts
		end,
	},

	{
		"folke/which-key.nvim",
		optional = true,
		opts = {
			spec = {
				{ "<leader>m", group = "multicursor" },
			},
		},
	},
}

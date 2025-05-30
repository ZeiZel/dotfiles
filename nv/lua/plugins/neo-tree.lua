-- (Unicode chars)[https://en.wikibooks.org/wiki/Unicode/Character_reference/F0000-F0FFF]
return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	-- Rename file by snacks
	opts = function(_, opts)
		local function on_move(data)
			Snacks.rename.on_rename_file(data.source, data.destination)
		end
		local events = require("neo-tree.events")
		opts.event_handlers = opts.event_handlers or {}
		vim.list_extend(opts.event_handlers, {
			{ event = events.FILE_MOVED, handler = on_move },
			{ event = events.FILE_RENAMED, handler = on_move },
		})
	end,
	config = function()
		vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none", fg = "none" })
		vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none", fg = "none" })
		vim.diagnostic.config({
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = " ",
					[vim.diagnostic.severity.WARN] = " ",
					[vim.diagnostic.severity.INFO] = " ",
					[vim.diagnostic.severity.HINT] = " ",
				},
			},
		})

		local events = require("neo-tree.events")

		vim.cmd([[
			hi NeoTreeCursorLine gui=bold guibg=#333333
		]])

		require("neo-tree").setup({
			use_float = true,
			close_if_last_window = false,
			default_component_configs = {
				git_status = {
					symbols = {
						-- Change type
						added = "",
						modified = "󰏬",
						deleted = "󰍵",
						renamed = "󰧚", -- 󰏫
						-- Status type
						untracked = "󰀧",
						ignored = "󰎃", -- 
						unstaged = "󰄱",
						staged = "",
						conflict = "",
					},
				},
			},
			window = {
				auto_expand_width = false,
				width = 40,
				mapping_options = {
					noremap = true,
					nowait = true,
				},
			},
			filesystem = {
				bind_to_cwd = false,
				cwd_target = {
					sidebar = "tab",
					current = "window",
				},
				scan_mode = "deep",
				use_libuv_file_watcher = true,
				filtered_items = {
					visible = true,
					hide_dotfiles = false,
					hide_gitignored = false,
					hide_hidden = false,
				},
			},
			event_handlers = {
				{
					event = events.NEO_TREE_BUFFER_ENTER,
					handler = function()
						vim.cmd("highlight! Cursor blend=100")
					end,
				},
				{
					event = events.NEO_TREE_BUFFER_LEAVE,
					handler = function()
						vim.cmd("highlight! Cursor guibg=#5f87af blend=0")
					end,
				},
			},
			nesting_rules = {
				ts = { ".d.ts", "js", "css", "html", "scss" },
			},
		})
	end,
}

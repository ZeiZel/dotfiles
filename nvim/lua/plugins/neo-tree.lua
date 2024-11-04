-- (Unicode chars)[https://en.wikibooks.org/wiki/Unicode/Character_reference/F0000-F0FFF]
return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
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
		-- See ":help neo-tree-highlights" for a list of available highlight groups
		vim.cmd([[
			hi NeoTreeCursorLine gui=bold guibg=#333333
		]])

		require("neo-tree").setup({
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
				bind_to_cwd = false, -- true creates a 2-way binding between vim's cwd and neo-tree's root
				cwd_target = {
					sidebar = "tab", -- sidebar is when position = left or right
					current = "window", -- current is when position = current
				},
				scan_mode = "deep",
				use_libuv_file_watcher = true,
				filtered_items = {
					visible = true, -- when true, they will just be displayed differently than normal items
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

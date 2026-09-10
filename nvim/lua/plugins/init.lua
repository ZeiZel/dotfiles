-- Colour scheme. The terminal (Ghostty) runs Catppuccin Mocha, so the editor
-- runs the same palette: with a transparent editor background the two would
-- otherwise disagree on every uncovered cell.
return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		priority = 1000,
		opts = function()
			local blend = require("catppuccin.utils.colors").blend

			return {
				flavour = "mocha",
				-- The terminal already paints the background at 96% opacity;
				-- painting it again here would flatten that.
				transparent_background = true,
				show_end_of_buffer = false,
				term_colors = true,
				no_italic = false,
				styles = {
					comments = { "italic" },
					conditionals = { "italic" },
					keywords = { "italic" },
					types = {},
					functions = {},
					variables = {},
				},
				integrations = {
					blink_cmp = true,
					dadbod_ui = true,
					dap = true,
					dap_ui = true,
					diffview = true,
					dropbar = { enabled = true, color_mode = true },
					flash = true,
					gitsigns = true,
					grug_far = true,
					illuminate = { enabled = true, lsp = true },
					indent_blankline = { enabled = true, scope_color = "lavender" },
					lsp_trouble = true,
					markdown = true,
					mason = true,
					mini = { enabled = true },
					native_lsp = {
						enabled = true,
						virtual_text = {
							errors = { "italic" },
							hints = { "italic" },
							warnings = { "italic" },
						},
						inlay_hints = { background = true },
					},
					neogit = true,
					neotest = true,
					noice = true,
					notifier = true,
					overseer = true,
					render_markdown = true,
					semantic_tokens = true,
					snacks = { enabled = true, indent_scope_color = "lavender" },
					telescope = { enabled = true },
					treesitter = true,
					treesitter_context = true,
					which_key = true,
				},
				custom_highlights = function(c)
					-- The current-line band must read as a tint of the theme, not
					-- as a grey highlight. Blending a surface into the base only
					-- lifts brightness and comes out neutral, so an accent is
					-- blended instead. Mocha's base is blue-heavy, which drags
					-- `pink` on its own back towards violet; warming it with the
					-- rose accent first pushes the hue past magenta, and 22% keeps
					-- the band dark enough to read text over.
					local rose = blend(c.pink, c.red, 0.25)
					local cursor_line = blend(rose, c.base, 0.22)
					local selection = blend(c.lavender, c.base, 0.22)

					return {
						CursorLine = { bg = cursor_line },
						CursorColumn = { bg = cursor_line },
						CursorLineNr = { fg = c.lavender, style = { "bold" } },
						-- Keep the sign/fold columns on the same band so the line
						-- reads as one strip across the whole width.
						CursorLineSign = { bg = cursor_line },
						CursorLineFold = { bg = cursor_line },
						Visual = { bg = selection },
						VisualNOS = { bg = selection },
						Search = { bg = blend(c.yellow, c.base, 0.28), fg = c.text },
						IncSearch = { bg = blend(c.peach, c.base, 0.45), fg = c.text },
						CurSearch = { bg = blend(c.peach, c.base, 0.45), fg = c.text },
						MatchParen = { fg = c.peach, style = { "bold" } },
						WinSeparator = { fg = c.surface0, bg = "NONE" },
						-- Whitespace hints are meant to be legible, not loud.
						Whitespace = { fg = blend(c.overlay0, c.base, 0.45) },
						NonText = { fg = blend(c.overlay0, c.base, 0.45) },
						-- Panels must show the terminal background, exactly like the
						-- editor. Linking rather than clearing the background is
						-- deliberate: a group whose only attribute is `bg = "NONE"`
						-- counts as undefined, and edgy's `default` link to
						-- NormalFloat would then win and repaint the panel.
						EdgyNormal = { link = "Normal" },
						EdgyWinBar = { fg = c.lavender, bg = "NONE", style = { "bold" } },
						EdgyWinBarNC = { fg = c.overlay0, bg = "NONE" },
						-- Unfocused Snacks windows: this is what darkens the
						-- explorer and the docked terminal while the cursor is in
						-- the editor.
						SnacksNormalNC = { link = "Normal" },
						-- The picker's input and list are floats that Snacks routes
						-- to NormalFloat, which catppuccin keeps opaque on purpose.
						-- Making them transparent is safe for both layouts because
						-- of how the windows stack: in the explorer sidebar the
						-- window underneath is the layout box, a plain split that
						-- already shows the terminal background, while a floating
						-- picker keeps its own opaque `SnacksPickerBox` float
						-- underneath and stays readable over code.
						SnacksPickerList = { link = "Normal" },
						SnacksPickerInput = { link = "Normal" },
						SnacksPickerListBorder = { fg = c.surface1, bg = "NONE" },
						SnacksPickerInputBorder = { fg = c.surface1, bg = "NONE" },
						SnacksPickerListTitle = { fg = c.lavender, bg = "NONE" },
						SnacksPickerInputTitle = { fg = c.lavender, bg = "NONE" },
					}
				end,
			}
		end,
	},
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "catppuccin-mocha",
		},
	},
}

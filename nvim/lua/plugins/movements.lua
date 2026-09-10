return {
	-- Multiple cursors. One owner: every cursor is a real Vim cursor that
	-- replays normal-mode commands, so operators, text objects, registers and
	-- counts behave exactly as they do with a single cursor.
	{
		"jake-stewart/multicursor.nvim",
		branch = "1.0",
		lazy = true,
		keys = function()
			local function mc()
				return require("multicursor-nvim")
			end

			local both = { "n", "x" }
			return {
				-- Occurrence based, the VS Code / WebStorm "select next" flow.
				{
					"<C-n>",
					function()
						mc().matchAddCursor(1)
					end,
					mode = both,
					desc = "Cursor at next match",
				},
				{
					"<leader>mn",
					function()
						mc().matchAddCursor(1)
					end,
					mode = both,
					desc = "Cursor at next match",
				},
				{
					"<leader>mN",
					function()
						mc().matchAddCursor(-1)
					end,
					mode = both,
					desc = "Cursor at previous match",
				},
				{
					"<leader>mx",
					function()
						mc().matchSkipCursor(1)
					end,
					mode = both,
					desc = "Skip next match",
				},
				{
					"<leader>mX",
					function()
						mc().matchSkipCursor(-1)
					end,
					mode = both,
					desc = "Skip previous match",
				},
				{
					"<leader>ma",
					function()
						mc().matchAllAddCursors()
					end,
					mode = both,
					desc = "Cursor at every match in buffer",
				},

				-- Column based, the classic block-edit flow.
				{
					"<leader>mj",
					function()
						mc().lineAddCursor(1)
					end,
					mode = both,
					desc = "Cursor on line below",
				},
				{
					"<leader>mk",
					function()
						mc().lineAddCursor(-1)
					end,
					mode = both,
					desc = "Cursor on line above",
				},
				{
					"<leader>mJ",
					function()
						mc().lineSkipCursor(1)
					end,
					mode = both,
					desc = "Skip line below",
				},
				{
					"<leader>mK",
					function()
						mc().lineSkipCursor(-1)
					end,
					mode = both,
					desc = "Skip line above",
				},

				-- Cursor set management.
				{
					"<leader>mt",
					function()
						mc().toggleCursor()
					end,
					mode = both,
					desc = "Toggle cursor here",
				},
				{
					"<leader>mc",
					function()
						mc().clearCursors()
					end,
					mode = both,
					desc = "Clear cursors",
				},
				{
					"<leader>mr",
					function()
						mc().restoreCursors()
					end,
					desc = "Restore cleared cursors",
				},
				{
					"<leader>mg",
					function()
						mc().alignCursors()
					end,
					desc = "Align cursor columns",
				},

				-- Visual selection sources.
				{
					"<leader>mp",
					function()
						mc().splitCursors()
					end,
					mode = "x",
					desc = "Split selection by pattern",
				},
				{
					"<leader>mm",
					function()
						mc().matchCursors()
					end,
					mode = "x",
					desc = "Cursor at pattern inside selection",
				},
				{
					"<leader>mI",
					function()
						mc().insertVisual()
					end,
					mode = "x",
					desc = "Insert at start of each selection",
				},
				{
					"<leader>mA",
					function()
						mc().appendVisual()
					end,
					mode = "x",
					desc = "Append at end of each selection",
				},
				{
					"<leader>mT",
					function()
						mc().transposeCursors(1)
					end,
					mode = "x",
					desc = "Transpose selection contents",
				},

				-- Mouse, for the moments a pointer is genuinely faster.
				{
					"<C-LeftMouse>",
					function()
						mc().handleMouse()
					end,
					desc = "Toggle cursor under pointer",
				},
				{
					"<C-LeftDrag>",
					function()
						mc().handleMouseDrag()
					end,
					desc = "Drag cursors",
				},
				{
					"<C-LeftRelease>",
					function()
						mc().handleMouseRelease()
					end,
					desc = "Release cursor drag",
				},
			}
		end,
		config = function()
			local mc = require("multicursor-nvim")
			mc.setup()

			-- While cursors exist the editor is in a distinct mode. These keys are
			-- only bound during that layer, so nothing is shadowed the rest of the
			-- time.
			mc.addKeymapLayer(function(layer)
				layer({ "n", "x" }, "<C-n>", function()
					mc.matchAddCursor(1)
				end)
				layer({ "n", "x" }, "<C-p>", function()
					mc.matchSkipCursor(1)
				end)
				layer({ "n", "x" }, "<C-Left>", mc.prevCursor)
				layer({ "n", "x" }, "<C-Right>", mc.nextCursor)
				layer("n", "<Esc>", function()
					if not mc.cursorsEnabled() then
						mc.enableCursors()
					else
						mc.clearCursors()
					end
				end)
			end)
		end,
	},

	{
		"gbprod/yanky.nvim",
		recommended = true,
		desc = "Better Yank/Paste",
		event = "LazyFile",
		opts = {
			highlight = { timer = 150 },
		},
		keys = {
			{
				"<leader>p",
				function()
					if LazyVim.pick.picker.name == "telescope" then
						require("telescope").extensions.yank_history.yank_history({})
					else
						vim.cmd([[YankyRingHistory]])
					end
				end,
				mode = { "n", "x" },
				desc = "Open Yank History",
			},
			-- stylua: ignore
			{ "y",  "<Plug>(YankyYank)",                      mode = { "n", "x" },                           desc = "Yank Text" },
			{
				"p",
				"<Plug>(YankyPutAfter)",
				mode = { "n", "x" },
				desc = "Put Text After Cursor",
			},
			{
				"P",
				"<Plug>(YankyPutBefore)",
				mode = { "n", "x" },
				desc = "Put Text Before Cursor",
			},
			{
				"gp",
				"<Plug>(YankyGPutAfter)",
				mode = { "n", "x" },
				desc = "Put Text After Selection",
			},
			{
				"gP",
				"<Plug>(YankyGPutBefore)",
				mode = { "n", "x" },
				desc = "Put Text Before Selection",
			},
			{
				"[y",
				"<Plug>(YankyCycleForward)",
				desc = "Cycle Forward Through Yank History",
			},
			{
				"]y",
				"<Plug>(YankyCycleBackward)",
				desc = "Cycle Backward Through Yank History",
			},
			{
				"]p",
				"<Plug>(YankyPutIndentAfterLinewise)",
				desc = "Put Indented After Cursor (Linewise)",
			},
			{
				"[p",
				"<Plug>(YankyPutIndentBeforeLinewise)",
				desc = "Put Indented Before Cursor (Linewise)",
			},
			{
				"]P",
				"<Plug>(YankyPutIndentAfterLinewise)",
				desc = "Put Indented After Cursor (Linewise)",
			},
			{
				"[P",
				"<Plug>(YankyPutIndentBeforeLinewise)",
				desc = "Put Indented Before Cursor (Linewise)",
			},
			{ ">p", "<Plug>(YankyPutIndentAfterShiftRight)", desc = "Put and Indent Right" },
			{ "<p", "<Plug>(YankyPutIndentAfterShiftLeft)", desc = "Put and Indent Left" },
			{
				">P",
				"<Plug>(YankyPutIndentBeforeShiftRight)",
				desc = "Put Before and Indent Right",
			},
			{ "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)", desc = "Put Before and Indent Left" },
			{
				"=p",
				"<Plug>(YankyPutAfterFilter)",
				desc = "Put After Applying a Filter",
			},
			{
				"=P",
				"<Plug>(YankyPutBeforeFilter)",
				desc = "Put Before Applying a Filter",
			},
		},
	},
}

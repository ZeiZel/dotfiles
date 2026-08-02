return {
	{
		-- Override the SQL extra's Dadbod UI spec without importing the extra again.
		"kristijanhusak/vim-dadbod-ui",
		config = function()
			vim.g.db_ui_win_position = "right"
			vim.g.db_ui_winwidth = 42

			local group = vim.api.nvim_create_augroup("dotfiles_dbui_navigation", { clear = true })
			vim.api.nvim_create_autocmd("User", {
				pattern = "DBUIOpened",
				group = group,
				callback = function()
					local buffer = vim.api.nvim_get_current_buf()
					vim.schedule(function()
						if
							not vim.api.nvim_buf_is_valid(buffer)
							or vim.bo[buffer].filetype ~= "dbui"
						then
							return
						end

						local opts = { buffer = buffer, silent = true }
						vim.keymap.set(
							"n",
							"<C-h>",
							"<C-w>h",
							vim.tbl_extend("force", opts, { desc = "DBUI: focus left window" })
						)
						vim.keymap.set(
							"n",
							"<C-j>",
							"<C-w>j",
							vim.tbl_extend("force", opts, { desc = "DBUI: focus lower window" })
						)
						vim.keymap.set(
							"n",
							"<C-k>",
							"<C-w>k",
							vim.tbl_extend("force", opts, { desc = "DBUI: focus upper window" })
						)
						vim.keymap.set(
							"n",
							"<C-l>",
							"<C-w>l",
							vim.tbl_extend("force", opts, { desc = "DBUI: focus right window" })
						)
					end)
				end,
			})
		end,
	},
}

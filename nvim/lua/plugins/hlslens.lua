-- jump between matched instances
return {
	{
		"kevinhwang91/nvim-hlslens",
		lazy = true,
		config = function()
			require("hlslens").setup({
				build_position_cb = function(plist, _, _, _)
					require("scrollbar.handlers.search").handler.show(plist.start_pos)
				end,
			})

			vim.cmd([[
        augroup scrollbar_search_hide
            autocmd!
            autocmd CmdlineLeave : lua require('scrollbar.handlers.search').handler.hide()
        augroup END
    ]])
		end,
	},
}

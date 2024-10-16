return {
	"folke/noice.nvim",
	event = "VeryLazy",
	dependencies = { "MunifTanjim/nui.nvim" },
	config = function()
		require("noice").setup({
			presets = {
				bottom_search = false, -- use a classic bottom cmdline for search
				command_palette = true, -- position the cmdline and popupmenu together
				long_message_to_split = true, -- long messages will be sent to a split
				lsp_doc_border = false, -- add a border to hover docs and signature help
			},
			lsp = {
				signature = {
					enabled = false,
				},
				hover = {
					enabled = false,
				},
			},
			progress = {
				enabled = false,
			},
			signature = { enabled = false },
			override = {
				["vim.lsp.util.convert_input_to_markdown_lines"] = false,
				["vim.lsp.util.stylize_markdown"] = false,
				["cmp.entry.get_documentation"] = false, -- requires hrsh7th/nvim-cmp
			},
		})
	end,
	init = function()
		vim.g.lsp_handlers_enabled = false
	end,
}

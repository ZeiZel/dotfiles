return {
	"christoomey/vim-tmux-navigator", -- tmux & split window navigation
	"majutsushi/tagbar",
	"nvim-lua/plenary.nvim", -- lua functions that many plugins use
	"kevinhwang91/nvim-bqf", -- better quickfix
	"mfussenegger/nvim-dap", -- debugger
	"HiPhish/rainbow-delimiters.nvim",
	"gpanders/editorconfig.nvim",
	-- yaml support
	{
		"cuducos/yaml.nvim",
		ft = { "yaml" },
	},
	{
		{
			"Bekaboo/dropbar.nvim",
			dependencies = {
				"nvim-telescope/telescope-fzf-native.nvim",
			},
		},
	},
	{
		"OXY2DEV/foldtext.nvim",
		lazy = false,
	},
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		lazy = true,
		opts = {
			enable_autocmd = false,
		},
	},
	{
		"jay-babu/project.nvim",
		main = "project_nvim",
		event = "VeryLazy",
		opts = { ignore_lsp = { "lua_ls" } },
	},
	{
		"nvimdev/lspsaga.nvim",
		config = function()
			require("lspsaga").setup({})
		end,
	},
	{
		"ggandor/leap.nvim",
		lazy = false,
		config = function()
			require("leap").add_default_mappings(true)
		end,
	},
}

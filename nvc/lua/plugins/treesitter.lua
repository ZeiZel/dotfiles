return {
	{
		'nvim-treesitter/nvim-treesitter',
		config = function()
			require('nvim-treesitter.configs').setup({
				ensure_installed = { "go", "rust", "lua", "typescript", "javascript", "c", "vim", "vimdoc", "markdown", "markdown_inline" },
				auto_install = true,
				highlight = {
					enable = true,
				}
			})
		end
	}
}

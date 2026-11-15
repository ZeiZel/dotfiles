return {
	{
		"nvim-treesitter/nvim-treesitter",
		init = function()
			-- `tree-sitter build` guards each compile with a lock file in
			-- `~/.cache/tree-sitter/lock/` and removes it on success, so a
			-- leftover lock always means a build that was killed mid-compile
			-- (closing nvim during the first parser install is enough). Every
			-- later install then refuses to run until the file is deleted by
			-- hand. Purge those leftovers before the plugin's startup
			-- auto-install trips over them, but only the ones nothing holds
			-- with flock: a live build in a concurrent nvim instance keeps its
			-- lock locked, and `flock -n` fails on it.
			local cache_root = vim.env.XDG_CACHE_HOME
			if not cache_root or cache_root == "" then
				cache_root = vim.fs.joinpath(vim.uv.os_homedir(), ".cache")
			end
			local lock_dir = vim.fs.joinpath(cache_root, "tree-sitter", "lock")
			if not vim.uv.fs_stat(lock_dir) then
				return
			end
			for lock in vim.fs.dir(lock_dir) do
				if lock:match("%.lock$") then
					local path = vim.fs.joinpath(lock_dir, lock)
					vim.fn.system({ "flock", "-n", path, "true" })
					if vim.v.shell_error == 0 then
						vim.uv.fs_unlink(path)
					end
				end
			end
		end,
		opts = {
			ensure_installed = {
				-- devops
				"helm",
				"bash",
				"dockerfile",
				"cmake",
				"terraform",
				"hcl",

				-- git
				"git_config",
				"gitcommit",
				"git_rebase",
				"gitignore",
				"gitattributes",

				-- web
				"html",
				"typescript",
				"javascript",
				"tsx",
				"svelte",
				"vue",
				"css",

				-- db
				"prisma",

				-- files
				"json5",
				"yaml",
				"markdown",
				"markdown_inline",

				-- go
				"go",
				"gomod",
				"gowork",
				"gosum",

				-- python
				"python",

				-- sql
				"query",

				-- utils
				"regex",

				-- lua
				"lua",
				"vim",
			},
		},
	},
}

return {
	-- helm
	{ "towolf/vim-helm", ft = "helm" },
	-- terraform
	{
		"ANGkeith/telescope-terraform-doc.nvim",
		ft = { "terraform", "hcl" },
		config = function()
			LazyVim.on_load("telescope.nvim", function()
				require("telescope").load_extension("terraform_doc")
			end)
		end,
	},
	{
		"cappyzawa/telescope-terraform.nvim",
		ft = { "terraform", "hcl" },
		config = function()
			LazyVim.on_load("telescope.nvim", function()
				require("telescope").load_extension("terraform")
			end)
		end,
	},
	-- ansible
	{
		"mfussenegger/nvim-ansible",
		ft = {},
		keys = {
			{
				"<leader>ta",
				function()
					require("ansible").run()
				end,
				desc = "Ansible Run Playbook/Role",
				silent = true,
			},
		},
	},
	-- cmake
	{ "cmake-tools.nvim" },
	{
		"Civitasv/cmake-tools.nvim",
		lazy = true,
		init = function()
			local loaded = false
			local function check()
				local cwd = vim.uv.cwd()
				if vim.fn.filereadable(cwd .. "/CMakeLists.txt") == 1 then
					require("lazy").load({ plugins = { "cmake-tools.nvim" } })
					loaded = true
				end
			end
			check()
			vim.api.nvim_create_autocmd("DirChanged", {
				callback = function()
					if not loaded then
						check()
					end
				end,
			})
		end,
		opts = {},
	},
}

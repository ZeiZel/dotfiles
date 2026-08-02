local function open_cli(argv, title)
	local executable = argv[1]
	if vim.fn.executable(executable) ~= 1 then
		LazyVim.warn(
			("`%s` is not installed or is not available in PATH. Run the dotfiles provisioning first."):format(
				executable
			),
			{ title = title }
		)
		return
	end

	Snacks.terminal(argv, {
		cwd = LazyVim.root.get(),
		win = {
			border = "rounded",
			title = (" %s "):format(title),
		},
	})
end

return {
	{
		"folke/snacks.nvim",
		init = function()
			vim.api.nvim_create_user_command("Lazydocker", function()
				open_cli({ "lazydocker" }, "Lazydocker")
			end, { desc = "Toggle Lazydocker for the project root" })
		end,
		keys = {
			{ "<leader>ld", "<cmd>Lazydocker<cr>", desc = "Lazydocker" },
		},
	},
}

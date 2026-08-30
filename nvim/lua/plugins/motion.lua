local function excluded_environment()
	-- Neovide already provides its own animated renderer. Keep the terminal
	-- motion plugins out of GUI sessions, remote shells and headless checks.
	return vim.g.neovide ~= nil
		or vim.env.SSH_CONNECTION ~= nil
		or vim.env.SSH_CLIENT ~= nil
		or vim.env.SSH_TTY ~= nil
		or #vim.api.nvim_list_uis() == 0
end

local function eligible_buffer(buf)
	if excluded_environment() or not vim.api.nvim_buf_is_valid(buf) then
		return false
	end

	local buffer = vim.bo[buf]
	local name = vim.api.nvim_buf_get_name(buf)
	if buffer.buftype ~= "" or not buffer.modifiable or name == "" then
		return false
	end

	-- Avoid animation overhead for generated/vendor/database dumps. getfsize()
	-- returns -1/-2 for transient or unreadable files, which remain eligible.
	local size = vim.fn.getfsize(name)
	return size <= 1024 * 1024 or size < 0
end

local function lazy_load_motion_plugins()
	local requested = false
	local group = vim.api.nvim_create_augroup("dotfiles_terminal_motion", { clear = true })

	local function visual_or_select_mode()
		local mode = vim.fn.mode(1)
		return mode:sub(1, 1) == "v"
			or mode:sub(1, 1) == "V"
			or mode:sub(1, 1) == "\022"
			or mode:sub(1, 1) == "s"
			or mode:sub(1, 1) == "S"
	end

	local function update_smear_state(args)
		local buf = args.buf ~= 0 and args.buf or vim.api.nvim_get_current_buf()
		-- SmearCursorToggle is intentionally not used here: this assignment is
		-- deterministic when moving between normal, special and large buffers.
		require("smear_cursor").enabled = eligible_buffer(buf) and not visual_or_select_mode()
	end

	local function install_smear_state_autocmd()
		local group = vim.api.nvim_create_augroup("dotfiles_terminal_smear_state", { clear = true })
		vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "ModeChanged" }, {
			group = group,
			callback = update_smear_state,
		})
	end

	local function try_load(args)
		local buf = args.buf ~= 0 and args.buf or vim.api.nvim_get_current_buf()
		if requested or not eligible_buffer(buf) then
			return
		end

		requested = true
		vim.api.nvim_clear_autocmds({ group = group })
		vim.schedule(function()
			require("lazy").load({
				plugins = { "neoscroll.nvim", "smear-cursor.nvim" },
			})
			install_smear_state_autocmd()
			-- Apply the eligibility decision to the buffer that triggered the load;
			-- do not rely on a later BufEnter to initialize Smear Cursor.
			update_smear_state({ buf = buf })
		end)
	end

	-- BufReadPost/BufNewFile/BufEnter run after a real buffer is ready. The
	-- loader removes itself as soon as the first eligible file is found.
	vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "BufEnter" }, {
		group = group,
		callback = try_load,
	})
end

return {
	{
		"karb94/neoscroll.nvim",
		branch = "master",
		lazy = true,
		init = lazy_load_motion_plugins,
		opts = {
			-- Keep native arrows and regular j/k untouched; these are only the
			-- standard viewport motions and use the plugin's low-overhead path.
			mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb" },
			hide_cursor = true,
			stop_eof = true,
			respect_scrolloff = false,
			cursor_scrolls_alone = true,
			easing = "quadratic",
			performance_mode = true,
			duration_multiplier = 0.55,
		},
	},
	{
		"sphamba/smear-cursor.nvim",
		branch = "main",
		lazy = true,
		opts = {
			enabled = true,
			-- Restrained values preserve terminal responsiveness while still
			-- providing a visible cursor trail on normal-sized source files.
			stiffness = 0.8,
			trailing_stiffness = 0.5,
			damping = 0.95,
			distance_stop_animating = 0.5,
			smear_between_buffers = false,
			smear_between_neighbor_lines = true,
			scroll_buffer_space = true,
		},
	},
}

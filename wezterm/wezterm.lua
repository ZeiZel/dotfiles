local wezterm = require("wezterm")

local config = wezterm.config_builder()

function scheme_for_appearance(appearance)
	if appearance:find("Dark") then
		return "Catppuccin Mocha"
	else
		return "Catppuccin Latte"
	end
end

config.window_background_opacity = 0.5
config.macos_window_background_blur = 30

-- Font settings
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = 16

-- Window setting/ appearance
config.window_decorations = "RESIZE"
config.enable_tab_bar = false

config.window_frame = {
	font = wezterm.font({ family = "0xProto Nerd Font" }),
	font_size = 20,
}

config.window_padding = {
	left = "0.0cell",
	right = "0.0cell",
	top = "0.0cell",
	bottom = "0.0cell",
}

config.initial_rows = 42
config.initial_cols = 124

config.enable_scroll_bar = false
config.scrollback_lines = 5000
config.default_workspace = "main"

-- Dim inactive panes
config.inactive_pane_hsb = {
	saturation = 0.24,
	brightness = 0.5,
}

-- Tab bar
-- config.enable_tab_bar = false
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false
config.status_update_interval = 1000

config.color_scheme = scheme_for_appearance(wezterm.gui.get_appearance())

wezterm.on("update-status", function(window, pane)
	local basename = function(s)
		return string.gsub(s, "(.*[/\\])(.*)", "%2")
	end

	-- Current working directory
	local cwd = pane:get_current_working_dir()
	if cwd then
		if type(cwd) == "userdata" then
			cwd = basename(cwd.file_path)
		else
			cwd = basename(cwd)
		end
	else
		cwd = ""
	end

	-- Current command
	local cmd = pane:get_foreground_process_name()
	cmd = cmd and basename(cmd) or ""

	-- Time
	local time = wezterm.strftime("%H:%M")

	-- Right status
	window:set_right_status(wezterm.format({
		{ Text = wezterm.nerdfonts.md_folder .. "  " .. cwd },
		{ Text = " | " },
		{ Foreground = { Color = "#e0af68" } },
		{ Text = wezterm.nerdfonts.fa_code .. "  " .. cmd },
		"ResetAttributes",
		{ Text = " | " },
		{ Text = wezterm.nerdfonts.md_clock .. "  " .. time },
		{ Text = "  " },
	}))
end)

return config

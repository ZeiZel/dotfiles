local wezterm = require("wezterm")

local config = wezterm.config_builder()

local function scheme_for_appearance(appearance)
	if appearance:find("Dark") then
		return "Catppuccin Mocha"
	else
		return "Catppuccin Latte"
	end
end

config.window_background_opacity = 0.96
config.macos_window_background_blur = 0

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
local appearance = "Dark"
if wezterm.gui then
	appearance = wezterm.gui.get_appearance()
end
config.color_scheme = scheme_for_appearance(appearance)

return config

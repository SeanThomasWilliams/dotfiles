-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices.

-- For example, changing the initial geometry for new windows:
--config.initial_cols = 120
--config.initial_rows = 28

-- or, changing the font size and color scheme.
config.font_size = 12
--config.font = wezterm.font 'JetBrains Mono'
--config.color_scheme = 'Brogrammer'
--config.color_scheme = 'Carbonfox'
--config.color_scheme = 'Citruszest'
config.color_scheme = 'Tokyo Night'
--config.color_scheme = 'Brogrammer (base16)'
--config.color_scheme = 'Builtin Pastel Dark'
--config.color_scheme = 'Circus (base16)'
--
config.hide_tab_bar_if_only_one_tab = true

config.front_end = "WebGpu"
--config.front_end = "OpenGL"
--config.animation_fps = 1
--config.cursor_blink_ease_in = 'Constant'
--config.cursor_blink_ease_out = 'Constant'
config.enable_wayland = false

-- Opinionated keybindings
config.enable_kitty_keyboard = true

-- Keep binary/glyph noise inside the terminal instead of showing GUI warnings.
config.warn_about_missing_glyphs = false

config.keys = {
	{
		key = 'Enter',
		mods = 'ALT',
		action = wezterm.action.DisableDefaultAssignment,
	},
	{
		key = "Enter",
		mods = "SHIFT",
		action = wezterm.action.SendString "\x0a",
	}
}

-- Finally, return the configuration to wezterm:
return config

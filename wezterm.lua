local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.color_scheme = "Tokyo Night"
config.colors = {
	background = "#212336",
}
config.font = wezterm.font("mesloLGS Nerd Font Mono")
config.font_size = 12

config.window_background_opacity = 1.0
config.skip_close_confirmation_for_processes_named = {
	"bash",
	"zsh",
}
config.window_close_confirmation = "NeverPrompt"
return config

-- Pull in the wezterm API
local wezterm = require("wezterm")

wezterm.on("gui-startup", function(cmd)
	local screen = wezterm.gui.screens().main
	local ratio = 0.7
	local width, height = screen.width * ratio, screen.height * ratio
	local tab, pane, window = wezterm.mux.spawn_window(cmd or {
		position = { x = (screen.width - width) / 2, y = (screen.height - height) / 2 },
	})
	-- window:gui_window():maximize()
	window:gui_window():set_inner_size(width, height)
end)

-- This will hold the configuration.
local config = wezterm.config_builder()

config.initial_rows = 50
config.initial_cols = 100

-- This is where you actually apply your config choices
--config.color_scheme = "Batman"
config.font = wezterm.font("Rec Mono Casual")
config.font_size = 19

config.enable_tab_bar = false

config.window_decorations = "RESIZE"

-- config.window_background_opacity = 0.8
-- config.macos_window_background_blur = 10

-- my coolnight colorscheme:
config.colors = {
	foreground = "#CBE0F0",
	background = "#011423",
	cursor_bg = "#47FF9C",
	cursor_border = "#47FF9C",
	cursor_fg = "#011423",
	selection_bg = "#033259",
	selection_fg = "#CBE0F0",
	ansi = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#0FC5ED", "#a277ff", "#24EAF7", "#24EAF7" },
	brights = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#A277FF", "#a277ff", "#24EAF7", "#24EAF7" },
}
config.keys = {
	{ key = "n", mods = "ALT", action = wezterm.action.SendString("~") },
}
-- Opzioni per migliorare il supporto della tastiera
config.send_composed_key_when_left_alt_is_pressed = true
--config.send_composed_key_when_right_alt_is_pressed = false
config.enable_csi_u_key_encoding = true

return config

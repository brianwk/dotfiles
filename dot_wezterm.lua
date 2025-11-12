local wezterm = require 'wezterm'
local config = {}

config.font_size = 15 
config.font = wezterm.font('Hack Nerd Font', { weight = 'Bold' })
config.color_scheme = 'Catppuccin Frappe'
config.window_decorations = "RESIZE"
config.enable_tab_bar = true

return config

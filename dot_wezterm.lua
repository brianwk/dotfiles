local wezterm = require 'wezterm'
local config = {}

config.font_size = 12 
config.font = wezterm.font('Hack Nerd Font', { weight = 'Bold' })
config.color_scheme = 'Catppuccin Frappe'
config.window_decorations = "RESIZE"
config.enable_tab_bar = false 
config.keys = {
  -- Disable the default "New Tab" hotkey (example for Ctrl+Shift+T)
  {
    key = 'w',
    mods = 'CMD',
    action = wezterm.action.CloseCurrentPane { confirm = true },
  },
  {
    key = 't',
    mods = 'SUPER',
    action = wezterm.action.DisableDefaultAssignment,
  },
  -- Add other custom key assignments below this line if needed
}

return config

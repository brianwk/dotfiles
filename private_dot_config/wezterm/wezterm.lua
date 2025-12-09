local wezterm = require 'wezterm'
local config = {}


config.front_end = "WebGpu"
config.max_fps = 144
config.font_size = 12 
config.font = wezterm.font('Hack Nerd Font', { weight = 'Bold' })
config.color_scheme = 'Catppuccin Mocha'
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
  {
    key = 'h',
    mods = 'CTRL',
    action = wezterm.action.ActivatePaneDirection 'Left',
  },
  {
    key = 'l',
    mods = 'CTRL',
    action = wezterm.action.ActivatePaneDirection 'Right',
  },
  {
    key = 'k',
    mods = 'CTRL',
    action = wezterm.action.ActivatePaneDirection 'Up',
  },
  {
    key = 'j',
    mods = 'CTRL',
    action = wezterm.action.ActivatePaneDirection 'Down',
  },}

local mux = wezterm.mux

function make_shell_pane(parent_pane, cmd, direction, size)
  local size = size or 0.10
  local shell_pane = parent_pane:split { size = size, direction = direction, args = cmd }
  return shell_pane
end

function setup (editor_pane, project)
   if project == "architary" then
     local shell_pane = make_shell_pane(editor_pane, { "yarn", "dev" }, "Bottom")
     local convex_pane = make_shell_pane(shell_pane, { "yarn", "dlx",  "convex", "dev" }, "Right", 0.05)
     local gitui_pane = make_shell_pane(editor_pane, { "gitui" }, "Right", 0.05)
   end
   if project == "PulseReport" then
     local shell_pane = make_shell_pane(editor_pane, { "yarn", "dlx", "expo", "run:ios", "-d", }, "Bottom")
     local gitui_pane = make_shell_pane(editor_pane, { "gitui" }, "Right", 0.05)
   end
end

local projects = {
 PulseReport = {
   cwd = wezterm.home_dir .. "/dev-current/treyapp/PulseReport"
 },
 architary = {
   cwd = wezterm.home_dir .. "/dev-current/architary/architary-nextjs"
 }
}

wezterm.on("gui-startup", function(cmd)
    for project, config in pairs(projects) do
      local tab, editor_pane, window = mux.spawn_window({
          workspace = project,
          cwd = config.cwd,
          args = { "hx", config.cwd }, --cmd and cmd.args,
          size = 0.75
      })
      window:set_title(project)
      setup(editor_pane, project)
    end
end)

return config

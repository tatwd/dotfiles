-- windows
-- sudo New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE/.wezterm.lua" -Target "$dotfielsDir/wezterm.lua"

local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.initial_cols = 92
config.initial_rows = 30

config.window_decorations = "RESIZE"
config.window_background_opacity = 0.98
--config.macos_window_background_blur = 20
config.window_padding = {
  left = '1cell',
  right = '1cell',
  top = '0.5cell',
  bottom = '0.5cell',
}
--config.set_environment_variables = {
--  COLORTERM = "truecolor",
--}

--config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true

config.font_size = 14
--config.font = wezterm.font 'JetBrainsMono Nerd Font'
--config.font = wezterm.font 'Maple Mono NF'
config.font = wezterm.font('Maple Mono NF', { weight = 'Regular' })
--config.font = wezterm.font('JetBrains Mono', { weight = 'Regular' })

config.color_scheme = 'Catppuccin Mocha'

config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }
config.keys = {
  { key = '|', mods = 'LEADER', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = '-', mods = 'LEADER', action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' } },
  { key = 'z', mods = 'LEADER', action = wezterm.action.TogglePaneZoomState },
--  { key = 'h', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Left' },
--  { key = 'j', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Down' },
--  { key = 'k', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Up' },
--  { key = 'l', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Right' },
  { key = 'x', mods = 'LEADER', action = wezterm.action.CloseCurrentPane { confirm = true } },
  { key = '[', mods = 'LEADER', action = wezterm.action.ActivateCopyMode },
  { key = '?', mods = 'LEADER', action = wezterm.action.ShowLauncher },
}


local is_windows = wezterm.target_triple == "x86_64-pc-windows-msvc"

if is_windows then
  config.default_prog = { 'pwsh.exe', '-NoLogo' }
  config.default_cwd = "D:\\works"
end

return config


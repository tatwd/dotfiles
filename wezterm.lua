-- windows
-- sudo New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE/.wezterm.lua" -Target "$dotfielsDir/wezterm.lua"

local wezterm = require 'wezterm'

local is_windows = wezterm.target_triple == "x86_64-pc-windows-msvc"

local config = wezterm.config_builder()

config.initial_cols = 80
config.initial_rows = 26

config.window_decorations = "RESIZE"
config.window_background_opacity = 0.98
config.macos_window_background_blur = 20
config.win32_system_backdrop = 'Mica'
config.window_padding = {
  left = '1cell',
  right = '1cell',
  top = '0.5cell',
  bottom = '0.5cell',
}
--config.set_environment_variables = {
--  COLORTERM = "truecolor",
--}

config.color_scheme = 'Catppuccin Mocha'

--config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = not is_windows
config.show_tab_index_in_tab_bar = true
config.show_tabs_in_tab_bar = true

config.font_size = 14
--config.font = wezterm.font 'JetBrainsMono Nerd Font'
--config.font = wezterm.font 'Maple Mono NF'
config.font = wezterm.font('Maple Mono NF', { weight = 'Regular' })
--config.font = wezterm.font('JetBrains Mono', { weight = 'Regular' })
config.command_palette_font = config.font
-- config.command_palette_rows = 14
config.command_palette_bg_color = '#1e2129'


config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }
config.keys = {
  { key = '=', mods = 'LEADER', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
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
-- config.debug_key_events = true


if is_windows then
  config.default_prog = { 'pwsh.exe', '-NoLogo' }
  config.default_cwd = "D:\\works"
end

return config


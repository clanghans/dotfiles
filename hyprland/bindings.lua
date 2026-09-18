-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

require("hypr.media")
require("hypr.clipboard")
require("hypr.tiling")
require("hypr.utilities")

-- See current bindings and descriptions:
--   hyprctl binds

hl.bind("SUPER + M", hl.dsp.exec_cmd("~/.config/hypr/scripts/swap_monitors.sh"), { description = "Swap monitors" })

-- Pin SUPER+RETURN to ghostty instead of leaving it to xdg-terminal-exec's
-- own pick (alacritty is also installed).
hl.unbind("SUPER + RETURN")
hl.bind("SUPER + RETURN", hl.dsp.exec_cmd("uwsm-app -- ${TERMINAL:-ghostty}"), { description = "Terminal" })

hl.bind("SUPER + SHIFT + I", hl.dsp.exec_cmd('uwsm-app -- ${BROWSER:-chromium} --app="https://gemini.google.com"'),
  { description = "Gemini" })

-- Override workspace switches to revert any monitor swap before switching.
-- Bind by physical key position (code:10-18 = number row keys 1-9), so this
-- custom keymap's symbol shifting doesn't affect the binding.
for i = 10, 18 do
  hl.unbind("SUPER + code:" .. i)
end
for i, code in ipairs({ 10, 11, 12, 13, 14, 15, 16, 17, 18 }) do
  hl.bind(
    "SUPER + code:" .. code,
    hl.dsp.exec_cmd("~/.config/hypr/scripts/workspace_switch.sh " .. i),
    { description = "Switch to workspace " .. i }
  )
end

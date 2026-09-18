-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- To disable every Omarchy default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.omarchy"), then add
-- only the bindings you want below:
--   omarchy_default_bindings = false

-- To disable all preinstalled app/webapp bindings, set:
--   omarchy_preinstalled_bindings = false

-- Add a new binding.
-- o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")

-- Change an existing binding by unbinding it first, then binding the key again.
-- This example changes SUPER+SPACE from the launcher to the Omarchy root menu.
-- hl.unbind("SUPER + SPACE")
-- o.bind("SUPER + SPACE", "Omarchy menu", "omarchy-menu toggle root")

-- Disable a default binding without replacing it.
-- hl.unbind("SUPER + SHIFT + B")

-- Logitech MX Keys examples:
-- o.bind("SUPER + SHIFT + S", nil, "omarchy-capture-screenshot")
-- o.bind("SUPER + H", nil, "voxtype record toggle")
-- o.bind("SUPER + PERIOD", nil, "omarchy-shell shell toggle omarchy.emojis")

o.bind("SUPER + M", "Swap monitors", "~/.config/hypr/scripts/swap_monitors.sh")

-- Omarchy 4 defaults SUPER+SHIFT+W to Omawrite; keep it on Typora instead.
hl.unbind("SUPER + SHIFT + W")
o.bind("SUPER + SHIFT + W", "Typora", "uwsm-app -- typora --enable-wayland-ime")

o.bind("SUPER + SHIFT + I", "Gemini", "omarchy-launch-webapp \"https://gemini.google.com\"")

-- Override workspace switches to revert any monitor swap before switching.
-- Bind by physical key position (code:10-18 = number row keys 1-9), so this
-- custom keymap's symbol shifting doesn't affect the binding.
for i = 10, 18 do
  hl.unbind("SUPER + code:" .. i)
end
for i, code in ipairs({ 10, 11, 12, 13, 14, 15, 16, 17, 18 }) do
  o.bind(
    "SUPER + code:" .. code,
    "Switch to workspace " .. i,
    "~/.config/hypr/scripts/workspace_switch.sh " .. i
  )
end

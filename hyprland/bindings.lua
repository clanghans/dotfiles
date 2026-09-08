-- All keybindings for this standalone config live here.

-- Add a new binding.
-- o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")

-- Change an existing binding by unbinding it first, then binding the key again.
-- hl.unbind("SUPER + SPACE")
-- o.bind("SUPER + SPACE", "Launcher", "wofi --show drun")

-- Disable a binding without replacing it.
-- hl.unbind("SUPER + SHIFT + B")

o.bind("SUPER + M", "Swap monitors", "~/.config/hypr/scripts/swap_monitors.sh")

o.bind("SUPER + SHIFT + W", "Typora", "uwsm-app -- typora --enable-wayland-ime")

o.bind("SUPER + SHIFT + I", "Gemini", "uwsm-app -- chromium --app=\"https://gemini.google.com\"")

-- Workspace switches revert any monitor swap before switching.
-- Bind by physical key position (code:10-18 = number row keys 1-9), so this
-- custom keymap's symbol shifting doesn't affect the binding.
for i, code in ipairs({ 10, 11, 12, 13, 14, 15, 16, 17, 18 }) do
  o.bind(
    "SUPER + code:" .. code,
    "Switch to workspace " .. i,
    "~/.config/hypr/scripts/workspace_switch.sh " .. i
  )
end

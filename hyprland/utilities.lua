hl.bind("SUPER + SPACE", hl.dsp.exec_cmd("wofi --show drun"), { description = "App launcher" })

hl.bind("SUPER + BACKSPACE", hl.dsp.exec_cmd("~/.config/hypr/scripts/window_transparency_toggle.sh"),
  { description = "Toggle window transparency" })

-- xkbcommon names the comma keysym "comma"; the upper-case "COMMA" does not match.
hl.bind("SUPER + comma", hl.dsp.exec_cmd("makoctl dismiss"), { description = "Dismiss last notification" })
hl.bind("SUPER + SHIFT + comma", hl.dsp.exec_cmd("makoctl dismiss --all"), { description = "Dismiss all notifications" })
hl.bind("SUPER + CTRL + comma", hl.dsp.exec_cmd("~/.config/hypr/scripts/toggle_dnd.sh"),
  { description = "Toggle silencing notifications" })
hl.bind("SUPER + ALT + comma", hl.dsp.exec_cmd("makoctl invoke"), { description = "Invoke last notification" })
-- mako only remembers the single most recently dismissed notification
-- (makoctl restore) -- there's no full scrollback history like Omarchy's
-- shell had. This is the closest native equivalent.
hl.bind("SUPER + SHIFT + ALT + comma", hl.dsp.exec_cmd("makoctl restore"), { description = "Restore last dismissed notification" })

hl.bind("SUPER + SHIFT + SPACE", hl.dsp.exec_cmd("~/.config/hypr/scripts/toggle_bar.sh"), { description = "Toggle top bar" })
hl.bind("SUPER + CTRL + I", hl.dsp.exec_cmd("~/.config/hypr/scripts/toggle_idle.sh"), { description = "Toggle locking on idle" })
hl.bind("SUPER + CTRL + N", hl.dsp.exec_cmd("~/.config/hypr/scripts/toggle_nightlight.sh"), { description = "Toggle nightlight" })

hl.bind("PRINT", hl.dsp.exec_cmd("hyprshot -m region"), { description = "Screenshot" })
hl.bind("ALT + PRINT", hl.dsp.exec_cmd("~/.config/hypr/scripts/toggle_recording.sh"), { description = "Screen recording" })
hl.bind("SUPER + PRINT", hl.dsp.exec_cmd("pkill hyprpicker || hyprpicker -a"), { description = "Color picker" })
hl.bind("SUPER + CTRL + PRINT", hl.dsp.exec_cmd("~/.config/hypr/scripts/ocr_capture.sh"),
  { description = "Extract text (OCR) from screenshot" })

hl.bind("SUPER + CTRL + A", hl.dsp.exec_cmd("pavucontrol"), { description = "Audio" })
hl.bind("SUPER + CTRL + B", hl.dsp.exec_cmd("blueman-manager"), { description = "Bluetooth" })
hl.bind("SUPER + CTRL + W", hl.dsp.exec_cmd("nm-connection-editor"), { description = "Network" })
hl.bind("SUPER + CTRL + T", hl.dsp.exec_cmd("uwsm-app -- ${TERMINAL:-ghostty} -e btop"), { description = "Activity" })

hl.bind("SUPER + CTRL + Z", function()
  local zoom = hl.get_config("cursor.zoom_factor") or 1
  hl.config({ cursor = { zoom_factor = zoom + 1 } })
end, { description = "Zoom in" })

hl.bind("SUPER + CTRL + ALT + Z", function()
  hl.config({ cursor = { zoom_factor = 1 } })
end, { description = "Reset zoom" })

hl.bind("SUPER + SHIFT + code:201", hl.dsp.exec_cmd("~/.config/hypr/scripts/power_menu.sh"), { description = "Power menu" })
hl.bind("SUPER + ESCAPE", hl.dsp.exec_cmd("~/.config/hypr/scripts/power_menu.sh"), { description = "Power menu" })
hl.bind("XF86PowerOff", hl.dsp.exec_cmd("~/.config/hypr/scripts/power_menu.sh"), { description = "Power menu", locked = true })
hl.bind("SUPER + CTRL + L", hl.dsp.exec_cmd("hyprlock"), { description = "Lock system" })

-- Dropped versus Omarchy: reminders, calculator, file-sharing (LocalSend/
-- Tailscale), transcode, agent picker, emoji picker, keybinding-cheatsheet
-- menus (see `hyprctl binds` instead), the generic root/system/toggle/
-- hardware/capture menu wrappers (direct binds above replace them),
-- webcam-overlay resize, laptop-only bindings (internal display toggle/
-- mirror, lid switch, clamshell), the bar-panel-cycling loop (waybar modules
-- are always visible/clickable), and the capture-region keyboard-nav layer
-- (hyprshot/slurp's own picker replaces it). None of these were in the
-- confirmed scope; add back individually if actually missed.

#!/usr/bin/env bash

# Make sure Hyprland is fully initialized before launching user apps
while ! hyprctl -j monitors >/dev/null 2>&1; do
    sleep 0.3
done

sleep 1

# Launch app $1 (args in $2..) via uwsm, or just warn if it's not installed.
launch() {
    local bin=$1
    shift
    if ! command -v "$bin" >/dev/null 2>&1; then
        echo "startup.sh: '$bin' not installed, skipping" >&2
        notify-send "Hyprland startup" "$bin not installed, skipping" 2>/dev/null || true
        return
    fi
    uwsm app -- "$bin" "$@" &
}

# Shell daemons: bar, notifications, wallpaper, clipboard history.
launch waybar -c ~/.config/hypr/waybar/config.jsonc -s ~/.config/hypr/waybar/style.css
launch mako -c ~/.config/hypr/mako/config.ini
# Static wallpaper (no theme-switcher, same image hyprlock uses, see
# theme/hyprlock-colors.conf). swaybg, not hyprpaper: hyprpaper 0.8.4 crashes
# on this system (hyprtoolkit Wayland-backend init bug), and swaybg's plain
# per-output image fill is all a static wallpaper needs anyway.
launch swaybg -o DP-1 -i ~/.config/hypr/theme/wallpaper.png -m fill -o DP-2 -i ~/.config/hypr/theme/wallpaper.png -m fill
if command -v cliphist >/dev/null 2>&1 && command -v wl-paste >/dev/null 2>&1; then
    wl-paste --watch cliphist store &
fi

sleep 1

# Launch your apps
launch "${TERMINAL:-ghostty}"
launch nautilus --new-window
launch keepassxc
launch obsidian -disable-gpu --enable-wayland-ime
launch "${BROWSER:-chromium}"

sleep 1

LAUNCH_OR_FOCUS="$(dirname "$0")/launch_or_focus.sh"
BROWSER_BIN="${BROWSER:-chromium}"

if command -v "$BROWSER_BIN" >/dev/null 2>&1; then
    "$LAUNCH_OR_FOCUS" chrome-chatgpt "$BROWSER_BIN" --app="https://chatgpt.com" &
    "$LAUNCH_OR_FOCUS" chrome-gemini "$BROWSER_BIN" --app="https://gemini.google.com" &
    "$LAUNCH_OR_FOCUS" chrome-web.whatsapp "$BROWSER_BIN" --app="https://web.whatsapp.com/" &
    "$LAUNCH_OR_FOCUS" chrome-mail.google.com "$BROWSER_BIN" --app="https://mail.google.com/mail/u/0/#inbox" &
else
    echo "startup.sh: '$BROWSER_BIN' not installed, skipping web apps" >&2
    notify-send "Hyprland startup" "$BROWSER_BIN not installed, skipping web apps" 2>/dev/null || true
fi

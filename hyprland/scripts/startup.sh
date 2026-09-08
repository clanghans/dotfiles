#!/usr/bin/env bash

# Make sure Hyprland is fully initialized before launching user apps
while ! hyprctl -j monitors >/dev/null 2>&1; do
    sleep 0.3
done

sleep 1

# Launch your apps
uwsm app -- "$TERMINAL" &
uwsm app -- nautilus --new-window &
uwsm app -- keepassxc &
uwsm app -- obsidian -disable-gpu --enable-wayland-ime &

uwsm-app -- "${BROWSER:-chromium}" &

sleep 1

LAUNCH_OR_FOCUS="$(dirname "$0")/launch_or_focus.sh"
BROWSER_BIN="${BROWSER:-chromium}"

"$LAUNCH_OR_FOCUS" chrome-chatgpt "$BROWSER_BIN" --app="https://chatgpt.com" &
"$LAUNCH_OR_FOCUS" chrome-gemini "$BROWSER_BIN" --app="https://gemini.google.com" &
"$LAUNCH_OR_FOCUS" chrome-web.whatsapp "$BROWSER_BIN" --app="https://web.whatsapp.com/" &
"$LAUNCH_OR_FOCUS" chrome-mail.google.com "$BROWSER_BIN" --app="https://mail.google.com/mail/u/0/#inbox" &

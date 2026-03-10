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

omarchy-launch-browser &

sleep 1

omarchy-launch-or-focus-webapp ChatGPT "https://chatgpt.com" &
omarchy-launch-or-focus-webapp WhatsApp "https://web.whatsapp.com/" &
omarchy-launch-or-focus-webapp GMail "https://mail.google.com/mail/u/0/#inbox" &

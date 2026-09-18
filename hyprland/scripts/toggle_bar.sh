#!/bin/bash
# Toggle waybar visibility.

if pgrep -x waybar >/dev/null; then
  pkill waybar
else
  setsid uwsm-app -- waybar &
fi

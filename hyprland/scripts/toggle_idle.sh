#!/bin/bash
# Toggle hypridle (lock-on-idle / dpms-off-on-idle) on or off.

if pgrep -x hypridle >/dev/null; then
  pkill hypridle
  notify-send "Hyprland" "Idle lock disabled" 2>/dev/null || true
else
  setsid uwsm-app -- hypridle &
  notify-send "Hyprland" "Idle lock enabled" 2>/dev/null || true
fi

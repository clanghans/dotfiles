#!/bin/bash
# Start/stop a region screen recording with wf-recorder.

if pgrep -x wf-recorder >/dev/null; then
  pkill -INT wf-recorder
  notify-send "Hyprland" "Recording stopped" 2>/dev/null || true
  exit 0
fi

region=$(slurp) || exit 0
mkdir -p ~/Videos
file=~/Videos/recording-$(date +%Y-%m-%d_%H-%M-%S).mp4

notify-send "Hyprland" "Recording started" 2>/dev/null || true
wf-recorder -g "$region" -f "$file" &

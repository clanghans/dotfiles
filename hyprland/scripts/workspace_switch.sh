#!/usr/bin/env bash
# Switch to workspace N, reverting any monitor swap first to avoid Hyprland crashes
# from workspace-monitor rule conflicts.

WS=$1
STATE_FILE="/tmp/hypr_monitors_swapped"

if [[ -f "$STATE_FILE" ]]; then
  read -r WS1 WS2 < "$STATE_FILE"
  rm "$STATE_FILE"
  hyprctl --batch "dispatch moveworkspacetomonitor $WS1 DP-1 ; dispatch moveworkspacetomonitor $WS2 DP-2 ; dispatch workspace $WS"
else
  hyprctl dispatch workspace "$WS"
fi

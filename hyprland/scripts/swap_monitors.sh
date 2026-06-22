#!/usr/bin/env bash

MON1="DP-1"
MON2="DP-2"
STATE_FILE="/tmp/hypr_monitors_swapped"

if [[ -f "$STATE_FILE" ]]; then
  # Already swapped - restore original positions
  read -r WS1 WS2 < "$STATE_FILE"
  hyprctl --batch "dispatch moveworkspacetomonitor $WS1 $MON1 ; dispatch moveworkspacetomonitor $WS2 $MON2"
  rm "$STATE_FILE"
else
  # Record current active workspaces then swap
  WS1=$(hyprctl monitors -j | jq -r --arg m "$MON1" '.[] | select(.name==$m) | .activeWorkspace.id')
  WS2=$(hyprctl monitors -j | jq -r --arg m "$MON2" '.[] | select(.name==$m) | .activeWorkspace.id')
  echo "$WS1 $WS2" > "$STATE_FILE"
  hyprctl dispatch swapactiveworkspaces "$MON1" "$MON2"
fi

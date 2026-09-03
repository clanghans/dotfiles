#!/usr/bin/env bash

MON1="DP-1"
MON2="DP-2"
STATE_FILE="/tmp/hypr_monitors_swapped"

if [[ -f "$STATE_FILE" ]]; then
  # Already swapped - restore original positions
  read -r WS1 WS2 < "$STATE_FILE"
  hyprctl eval "
    hl.dispatch(hl.dsp.workspace.move({ workspace = $WS1, monitor = \"$MON1\" }))
    hl.dispatch(hl.dsp.workspace.move({ workspace = $WS2, monitor = \"$MON2\" }))
  "
  rm "$STATE_FILE"
else
  # Record current active workspaces then swap
  WS1=$(hyprctl monitors -j | jq -r --arg m "$MON1" '.[] | select(.name==$m) | .activeWorkspace.id')
  WS2=$(hyprctl monitors -j | jq -r --arg m "$MON2" '.[] | select(.name==$m) | .activeWorkspace.id')
  echo "$WS1 $WS2" > "$STATE_FILE"
  hyprctl eval "hl.dispatch(hl.dsp.workspace.swap_monitors({ monitor1 = \"$MON1\", monitor2 = \"$MON2\" }))"
fi

#!/usr/bin/env bash
# Switch to workspace N, reverting any monitor swap first to avoid Hyprland crashes
# from workspace-monitor rule conflicts.

WS=$1
STATE_FILE="/tmp/hypr_monitors_swapped"

if [[ -f "$STATE_FILE" ]]; then
  read -r WS1 WS2 < "$STATE_FILE"
  rm "$STATE_FILE"
  hyprctl eval "
    hl.dispatch(hl.dsp.workspace.move({ workspace = $WS1, monitor = \"DP-1\" }))
    hl.dispatch(hl.dsp.workspace.move({ workspace = $WS2, monitor = \"DP-2\" }))
    hl.dispatch(hl.dsp.focus({ workspace = $WS }))
  "
else
  hyprctl eval "hl.dispatch(hl.dsp.focus({ workspace = $WS }))"
fi

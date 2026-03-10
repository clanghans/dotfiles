#!/usr/bin/env bash

MON1="DP-1"
MON2="DP-2"

STATE_FILE="/tmp/hypr_monitors_swapped"

if [[ -f "$STATE_FILE" ]]; then
  # Swapped -> restore default: odd on MON1, even on MON2
  for ws in 1 3 5 7 9; do
    hyprctl dispatch moveworkspacetomonitor "$ws" "$MON1"
  done
  for ws in 2 4 6 8; do
    hyprctl dispatch moveworkspacetomonitor "$ws" "$MON2"
  done
  rm "$STATE_FILE"
else
  # Default -> swap: odd on MON2, even on MON1
  for ws in 1 3 5 7 9; do
    hyprctl dispatch moveworkspacetomonitor "$ws" "$MON2"
  done
  for ws in 2 4 6 8; do
    hyprctl dispatch moveworkspacetomonitor "$ws" "$MON1"
  done
  touch "$STATE_FILE"
fi

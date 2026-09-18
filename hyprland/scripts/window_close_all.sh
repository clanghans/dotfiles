#!/bin/bash
# Close every window and return to workspace 1.

hyprctl clients -j |
  jq -r '.[].address' |
  while read -r addr; do
    hyprctl dispatch "hl.dsp.window.close({ window = \"address:$addr\" })" >/dev/null
  done

hyprctl dispatch 'hl.dsp.focus({ workspace = "1" })' >/dev/null

#!/bin/bash
# Toggle popping the focused window out into a fixed floating/pinned tile,
# or back into the tiling layout if it's already popped.
# Usage: window_pop.sh [width] [height] [x] [y]

width=${1:-1300}
height=${2:-900}
x=${3:-}
y=${4:-}

active=$(hyprctl activewindow -j)
pinned=$(jq -r '.pinned' <<<"$active")
addr=$(jq -r '.address' <<<"$active")
window="address:$addr"

[[ -z $addr ]] && exit 0

if [[ $pinned == "true" ]]; then
  hyprctl dispatch "hl.dsp.window.float({ window = \"$window\", action = \"toggle\" })" >/dev/null
  hyprctl dispatch "hl.dsp.window.pin({ window = \"$window\" })" >/dev/null
  hyprctl dispatch "hl.dsp.window.tag({ window = \"$window\", tag = \"-pop\" })" >/dev/null
else
  hyprctl dispatch "hl.dsp.window.float({ window = \"$window\", action = \"toggle\" })" >/dev/null
  hyprctl dispatch "hl.dsp.window.resize({ window = \"$window\", x = $width, y = $height })" >/dev/null

  if [[ -n $x && -n $y ]]; then
    hyprctl dispatch "hl.dsp.window.move({ window = \"$window\", x = $x, y = $y })" >/dev/null
  else
    hyprctl dispatch "hl.dsp.window.center({ window = \"$window\" })" >/dev/null
  fi

  hyprctl dispatch "hl.dsp.window.pin({ window = \"$window\" })" >/dev/null
  hyprctl dispatch "hl.dsp.window.alter_zorder({ window = \"$window\", mode = \"top\" })" >/dev/null
  hyprctl dispatch "hl.dsp.window.tag({ window = \"$window\", tag = \"+pop\" })" >/dev/null
fi

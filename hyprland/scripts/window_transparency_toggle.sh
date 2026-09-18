#!/bin/bash
# Toggle opacity for the focused window.

addr=$(hyprctl activewindow -j | jq -r '.address')
[[ -z $addr ]] && exit 0
hyprctl dispatch "hl.dsp.window.set_prop({ window = \"address:$addr\", prop = \"opaque\", value = \"toggle\" })" >/dev/null

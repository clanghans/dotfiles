#!/bin/bash
# Toggle "tiled fullscreen" (fullscreenstate client=2) for the focused window.

set -euo pipefail

fullscreen_client=$(hyprctl activewindow -j | jq -r '.fullscreenClient // 0')

if [[ $fullscreen_client == "2" ]]; then
  hyprctl dispatch 'hl.dsp.window.fullscreen_state({ internal = 0, client = 0 })' >/dev/null
else
  hyprctl dispatch 'hl.dsp.window.fullscreen_state({ internal = 0, client = 2 })' >/dev/null
fi

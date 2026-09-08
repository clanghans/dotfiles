#!/usr/bin/env bash
# Focus an existing window matching CLASS_OR_TITLE_PATTERN (case-insensitive
# regex), or run the launch command if no matching window exists.
#
# Usage: launch_or_focus.sh <pattern> <launch-cmd> [args...]

set -euo pipefail

PATTERN=$1
shift

ADDRESS=$(hyprctl clients -j | jq -r --arg p "$PATTERN" \
  '.[] | select((.class | test($p; "i")) or (.title | test($p; "i"))) | .address' | head -n1)

if [[ -n $ADDRESS ]]; then
  hyprctl eval "hl.dispatch(hl.dsp.focus({ window = \"address:$ADDRESS\" }))"
else
  exec setsid uwsm-app -- "$@"
fi

#!/bin/bash
# Toggle the active workspace's tiling layout between dwindle and scrolling.
# ponytail: runtime-only, doesn't persist across a config reload (Omarchy's
# version wrote a state file re-sourced on every reload). Add that back if
# losing the layout on reload becomes annoying.

active_workspace=$(hyprctl activeworkspace -j | jq -r '.id')
[[ $active_workspace =~ ^-?[0-9]+$ ]] || exit 1

current_layout=$(hyprctl activeworkspace -j | jq -r '.tiledLayout')
case "$current_layout" in
  dwindle) new_layout=scrolling ;;
  *) new_layout=dwindle ;;
esac

hyprctl eval "hl.workspace_rule({ workspace = \"$active_workspace\", layout = \"$new_layout\" })" >/dev/null
notify-send "Hyprland" "Workspace layout set to $new_layout" 2>/dev/null || true

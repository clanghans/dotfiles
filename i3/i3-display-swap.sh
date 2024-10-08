#!/usr/bin/env sh
set -x

# requires jq
JQ=$(command -v jq)
if ! [ -x "${JQ}" ]; then
    echo "jq could not be found"
    exit 1
fi

# obtain focused workspace
WORKSPACE=$(i3-msg -t get_workspaces | \
    jq '.[] | select(.focused==true).name' | \
    cut -d"\"" -f2)

# find second workspace
SECOND=$(i3-msg -t get_outputs | \
    jq -r '.[]|"\(.name):\(.current_workspace)"' | \
    grep -v ":null" | \
    grep -v ":$WORKSPACE" | \
    cut -d":" -f2)

# swap workspaces
i3-msg '[workspace="^.*[2468]|10$"]' move workspace to output right
i3-msg '[workspace="^.*[13579]$"]' move workspace to output left

# Focus on original workspaces
i3-msg -- workspace --no-auto-back-and-forth $SECOND
i3-msg -- workspace --no-auto-back-and-forth $WORKSPACE

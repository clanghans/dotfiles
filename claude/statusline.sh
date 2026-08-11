#!/usr/bin/env bash
# Read JSON session data from stdin
input=$(cat)

# Extract model display name using jq
model=$(echo "$input" | jq -r '.model.display_name // empty')

# Check for ponytail flag
flag="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/.ponytail-active"
output=""

if [ -f "$flag" ]; then
    mode=$(head -n1 "$flag" | tr -d '[:space:]')
    if [ -z "$mode" ] || [ "$mode" = "full" ]; then
        output='\033[38;5;108m[PONYTAIL]\033[0m'
    else
        output="\033[38;5;108m[PONYTAIL:$(printf '%s' "$mode" | tr '[:lower:]' '[:upper:]')]\033[0m"
    fi
fi

# Append model name
if [ -n "$model" ]; then
    if [ -n "$output" ]; then
        output="$output \033[38;5;146m[$model]\033[0m"
    else
        output="\033[38;5;146m[$model]\033[0m"
    fi
fi

printf '%b' "$output"

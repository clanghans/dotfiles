#!/bin/bash
# Select a screen region, OCR it, and copy the text to the clipboard.

grim -g "$(slurp)" - | tesseract - - 2>/dev/null | wl-copy
notify-send "Hyprland" "Extracted text copied to clipboard" 2>/dev/null || true

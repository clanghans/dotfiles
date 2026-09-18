#!/bin/bash
# Show clipboard history in wofi and copy the selected entry back to the clipboard.

cliphist list | wofi --dmenu --prompt "Clipboard" | cliphist decode | wl-copy

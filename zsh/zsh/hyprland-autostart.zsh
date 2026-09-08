# Launch Hyprland on tty1 login (paired with install.sh --autologin).
# Guard covers both a graphical session already running and re-sourcing in
# a shell spawned from inside one (e.g. a terminal on pts/*).
if [[ -z "$WAYLAND_DISPLAY" && -z "$DISPLAY" && "$(tty)" == "/dev/tty1" ]]; then
  exec uwsm start hyprland.desktop
fi

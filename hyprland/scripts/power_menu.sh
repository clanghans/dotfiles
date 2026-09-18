#!/bin/bash
# Power menu: lock, suspend, log out, reboot, or shut down.

choice=$(printf 'Lock\nSuspend\nLog out\nReboot\nShut down' | wofi --dmenu --prompt "Power")

case "$choice" in
  Lock) hyprlock ;;
  Suspend) systemctl suspend ;;
  "Log out") loginctl terminate-user "$USER" ;;
  Reboot) systemctl reboot ;;
  "Shut down") systemctl poweroff ;;
esac

#!/bin/bash
# Toggle hyprsunset between identity temperature and a warm nightlight tone.

ON_TEMP=4000
OFF_TEMP=6500

current_temp() {
  local output
  output=$(hyprctl hyprsunset temperature 2>/dev/null) || return
  grep -oE '[0-9]+' <<<"$output" | head -n1
}

if ! pgrep -x hyprsunset >/dev/null; then
  setsid uwsm-app -- hyprsunset &
fi

current=$(current_temp)
if [[ -z $current || $current == $OFF_TEMP ]]; then
  target=$ON_TEMP
else
  target=$OFF_TEMP
fi

# A freshly-started hyprsunset applies its default temperature at the end of
# its boot, overriding anything set before then, so resend until it sticks.
for _ in {1..10}; do
  hyprctl hyprsunset temperature "$target" >/dev/null 2>&1
  sleep 0.2
  [[ $(current_temp) == "$target" ]] && break
done

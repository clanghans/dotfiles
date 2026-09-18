-- Volume, mic mute, brightness, and media-playback keys.
-- No keyboard backlight on this hardware (brightnessctl -l shows no keyboard
-- backlight LED), so those Omarchy default bindings aren't ported here.

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+"),
  { description = "Volume up", locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
  { description = "Volume down", locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
  { description = "Mute", locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
  { description = "Mute microphone", locked = true })

hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set 5%+"),
  { description = "Brightness up", locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"),
  { description = "Brightness down", locked = true, repeating = true })
hl.bind("SHIFT + XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set 100%"),
  { description = "Brightness maximum", locked = true })
hl.bind("SHIFT + XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 1%"),
  { description = "Brightness minimum", locked = true })

hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { description = "Play/pause", locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { description = "Next track", locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { description = "Previous track", locked = true })

-- Optional: only bind if voxtype is actually installed.
local function cmd_present(command)
  local pipe = io.popen("command -v " .. command .. " 2>/dev/null")
  if not pipe then
    return false
  end
  local output = pipe:read("*a") or ""
  pipe:close()
  return output ~= ""
end

if cmd_present("voxtype") then
  hl.bind("SUPER + CTRL + X", hl.dsp.exec_cmd("voxtype record toggle"), { description = "Toggle dictation" })
  hl.bind("F9", hl.dsp.exec_cmd("voxtype record start"), { description = "Start dictation (push-to-talk)" })
  hl.bind("F9", hl.dsp.exec_cmd("voxtype record stop"), { description = "Stop dictation (push-to-talk)", release = true })
end

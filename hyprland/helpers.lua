-- Small helpers used by monitors.lua/input.lua/bindings.lua/looknfeel.lua/
-- autostart.lua below. Own, minimal replacement for what Omarchy's
-- default/hypr/helpers.lua used to provide, so this config no longer needs
-- Omarchy installed at all.

o = o or {}

-- o.bind(keys, description, command, options)
-- Thin wrapper around hl.bind: runs `command` as a shell command via
-- Hyprland's own exec dispatcher, with an optional human-readable
-- description carried in `options`.
function o.bind(keys, description, command, options)
  local opts = options or {}
  if description then
    opts.description = description
  end
  hl.bind(keys, hl.dsp.exec_cmd(command), opts)
end

-- o.window(match, rules)
-- Thin wrapper around hl.window_rule: `match` may be a plain string (used
-- as the window class regex) or a table of match fields.
function o.window(match, rules)
  rules.match = rules.match or {}
  if type(match) == "string" then
    rules.match.class = match
  else
    for key, value in pairs(match) do
      rules.match[key] = value
    end
  end
  hl.window_rule(rules)
end

-- o.exec_on_start(command)
-- Runs `command` once, after Hyprland has finished starting up.
function o.exec_on_start(command)
  hl.on("hyprland.start", function()
    hl.exec_cmd(command)
  end)
end

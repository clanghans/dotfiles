-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all

-- Monitor 1: DP-1 (Primary)
hl.monitor({ output = "DP-1", mode = "2560x1440@59.95", position = "0x0", scale = 1 })
-- Monitor 2: DP-2 (Right of DP-1)
hl.monitor({ output = "DP-2", mode = "2560x1440@59.95", position = "2560x0", scale = 1 })

-- Monitor 1 gets odd-numbered workspaces, monitor 2 gets even-numbered ones.
for _, ws in ipairs({ 1, 3, 5, 7, 9 }) do
  hl.workspace_rule({ workspace = tostring(ws), monitor = "DP-1", persistent = true })
end
for _, ws in ipairs({ 2, 4, 6, 8 }) do
  hl.workspace_rule({ workspace = tostring(ws), monitor = "DP-2", persistent = true })
end

-- Portrait/rotated secondary monitor (transform: 1 = 90°, 3 = 270°).
-- hl.monitor({ output = "DP-2", mode = "preferred", position = "auto", scale = 1, transform = 1 })

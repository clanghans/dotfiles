-- Learn how to configure Hyprland: https://wiki.hypr.land/Configuring/Start/
-- Standalone config: no Omarchy install required, just this repo.

local config_dir = (os.getenv("HOME") or "") .. "/.config/hypr"

-- o.bind/o.window/o.exec_on_start used by the files below.
dofile(config_dir .. "/helpers.lua")

dofile(config_dir .. "/monitors.lua")
dofile(config_dir .. "/input.lua")
dofile(config_dir .. "/bindings.lua")
dofile(config_dir .. "/looknfeel.lua")
dofile(config_dir .. "/autostart.lua")

-- Add any other personal Hyprland configuration below.
-- o.window("qemu", { workspace = "5" })

-- Launch apps straight onto their usual workspace.
o.window("^(Alacritty)$", { workspace = "1 silent" })
o.window("^(chromium).*$", { workspace = "2 silent" })
o.window("^(chrome-chatgpt).*$", { workspace = "3 silent" })
o.window("^(chrome-gemini).*$", { workspace = "3 silent" })
o.window("^(org.gnome.Nautilus).*$", { workspace = "4 silent" })
o.window("^.*obsidian.*$", { workspace = "6 silent" })
o.window("^.*thunderbird.*$", { workspace = "7 silent" })
o.window("^(chrome-mail.google.com).*$", { workspace = "7 silent" })
o.window("^(chrome-web.whatsapp).*$", { workspace = "8 silent" })
o.window("^.*keepassxc.*$", { workspace = "9 silent" })

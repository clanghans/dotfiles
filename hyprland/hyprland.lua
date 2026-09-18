-- Learn how to configure Hyprland: https://wiki.hypr.land/Configuring/Start/

-- Omarchy's bootstrap keeps path setup out of this user config.
dofile((os.getenv("OMARCHY_PATH") or "/usr/share/omarchy") .. "/default/hypr/bootstrap.lua")

-- Disable all Omarchy default bindings. Add your own in hypr/bindings.lua.
-- omarchy_default_bindings = false
--
-- Or disable only bindings for Omarchy's preinstalled apps/web apps while
-- keeping core window-manager bindings:
-- omarchy_preinstalled_bindings = false

-- Load Omarchy defaults.
require("default.hypr.omarchy")

-- Put your personal overrides in these files. They're loaded after Omarchy's
-- defaults so package updates can improve the defaults without rewriting your
-- ~/.config/hypr files.
require("hypr.monitors")
require("hypr.input")
require("hypr.bindings")
require("hypr.looknfeel")
require("hypr.autostart")

-- Toggle config flags dynamically.
require("default.hypr.toggles")

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

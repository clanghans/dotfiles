-- Learn how to configure Hyprland: https://wiki.hypr.land/Configuring/Start/

-- Let require() find our own files under ~/.config/hypr, e.g. require("hypr.monitors")
-- resolves to ~/.config/hypr/monitors.lua.
package.path = (os.getenv("HOME") or "") .. "/.config/?.lua;" .. package.path

require("hypr.monitors")
require("hypr.input")
require("hypr.bindings")
require("hypr.looknfeel")
require("hypr.autostart")

-- Launch apps straight onto their usual workspace.
hl.window_rule({ match = { class = "^(Alacritty)$" }, workspace = "1 silent" })
hl.window_rule({ match = { class = "^(chromium).*$" }, workspace = "2 silent" })
hl.window_rule({ match = { class = "^(chrome-chatgpt).*$" }, workspace = "3 silent" })
hl.window_rule({ match = { class = "^(chrome-gemini).*$" }, workspace = "3 silent" })
hl.window_rule({ match = { class = "^(org.gnome.Nautilus).*$" }, workspace = "4 silent" })
hl.window_rule({ match = { class = "^.*obsidian.*$" }, workspace = "6 silent" })
hl.window_rule({ match = { class = "^.*thunderbird.*$" }, workspace = "7 silent" })
hl.window_rule({ match = { class = "^(chrome-mail.google.com).*$" }, workspace = "7 silent" })
hl.window_rule({ match = { class = "^(chrome-web.whatsapp).*$" }, workspace = "8 silent" })
hl.window_rule({ match = { class = "^.*keepassxc.*$" }, workspace = "9 silent" })

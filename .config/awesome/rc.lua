-- awesome_mode: api-level=4:screen=on
pcall(require, "luarocks.loader") -- If LuaRocks is installed, make sure that packages installed through it area found (e.g. lgi). If LuaRocks is not installed, do nothing.
gears = require("gears")
awful = require("awful")
require("awful.autofocus")
wibox = require("wibox")
beautiful = require("beautiful")
lain = require("lain")
package.loaded["naughty.dbus"] = {} -- disable naughty from loading
ruled = require("ruled")
hotkeys_popup = require("awful.hotkeys_popup")

--require("awful.hotkeys_popup.keys") -- Enable hotkeys help widget for VIM and other apps when client with a matching name is opened:

require "awful.hotkeys_popup.keys.vim"
require "awful.hotkeys_popup.keys.firefox"
--require "awful.hotkeys_popup.keys.tmux"
--require "awful.hotkeys_popup.keys.qutebrowser"
--require "awful.hotkeys_popup.keys.termite"

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to another config (This code will only ever execute for the fallback config)
-- naughty.connect_signal("request::display_error", function(message, startup)
--     naughty.notification {
--         urgency = "critical",
--         title   = "Oops, an error happened"..(startup and " during startup!" or "!"),
--         message = message
--     }
-- end)
-- }}}

beautiful.init("~/.config/awesome/themes/aure/theme.lua")       -- Use regular hardcoded theme
--beautiful.init("~/.config/awesome/themes/aure/theme-pywal.lua")     -- Use pywal generated theme

terminal = "alacritty"
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e " .. editor
modkey       = "Mod4"
altkey       = "Mod1"
browser      = "firefox"

--require("menu") -- Generates default awesome menu on right click

require("tag-layout")

require("wibox-widgets")-- widgets 

require("wibox-bar") --renders top wibox bar

-- No borders when rearranging only 1 non-floating or maximized client
screen.connect_signal("arrange", function (s)
    local only_one = #s.tiled_clients == 1
    for _, c in pairs(s.clients) do
        if only_one and not c.floating or c.maximized or c.fullscreen then
            c.border_width = 0
        else
            c.border_width = beautiful.border_width
        end
    end
end)

require("keybindings") --source keybindings

require("rules") --source window rules

--require("notifications")

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:activate { context = "mouse_enter", raise = false }
end)

-- Switch focus to firefox automatically when browser link is opened
client.connect_signal("property::urgent", function(c)
    if c.class == "firefox" then
      awful.client.urgent.jumpto(false)
    end
end)

-- Switch focus to alacritty automatically when browser link is opened
client.connect_signal("property::urgent", function(c)
    if c.class == "alacritty" then
      awful.client.urgent.jumpto(false)
    end
end)

awful.spawn.with_shell("~/.config/awesome/autostart.sh")
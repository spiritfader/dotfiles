-- awesome_mode: api-level=4:screen=on
pcall(require, "luarocks.loader") -- If LuaRocks is installed, make sure that packages installed through it area found (e.g. lgi). If LuaRocks is not installed, do nothing.
gears = require("gears")
awful = require("awful")
require("awful.autofocus")
wibox = require("wibox")
beautiful = require("beautiful")
package.loaded["naughty.dbus"] = {} -- disable naughty from loading
ruled = require("ruled")
hotkeys_popup = require("awful.hotkeys_popup")

--require("awful.hotkeys_popup.keys") -- Enable hotkeys help widget for VIM and other apps when client with a matching name is opened:
require "awful.hotkeys_popup.keys.vim"
require "awful.hotkeys_popup.keys.firefox"
--require "awful.hotkeys_popup.keys.tmux"
--require "awful.hotkeys_popup.keys.qutebrowser"
--require "awful.hotkeys_popup.keys.termite"

-- custom hotkeys
require "awful.hotkeys_popup.keys.nvim"
require "awful.hotkeys_popup.keys.sysrq"

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

beautiful.init("~/.config/awesome/themes/aure/theme.lua")       -- Use regular theme

terminal = "alacritty"
--terminal = "st"
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e " .. editor
modkey       = "Mod4"
altkey       = "Mod1"
browser      = "flatpak --user run io.gitlab.librewolf-community"

-- Create a launcher widget and a main menu
--local myawesomemenu = {
--    { "Hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
--    { "Manual", string.format("%s -e man awesome", terminal) },
--    { "Edit config", string.format("%s -e %s %s", terminal, editor, awesome.conffile) },
--    { "Restart", awesome.restart },
--    { "Quit", function() awesome.quit() end },
-- }
-- 
-- awful.util.mymainmenu = freedesktop.menu.build {
--     before = {
--         { "Awesome", myawesomemenu, beautiful.awesome_icon },
--         -- other triads can be put here
--     },
--     after = {
--         { "Open terminal", terminal },
--         -- other triads can be put here
--     }
-- }
-- 
-- -- Hide the menu when the mouse leaves it
-- awful.util.mymainmenu.wibox:connect_signal("mouse::leave", function()
--     if not awful.util.mymainmenu.active_child or
--        (awful.util.mymainmenu.wibox ~= mouse.current_wibox and
--        awful.util.mymainmenu.active_child.wibox ~= mouse.current_wibox) then
--         awful.util.mymainmenu:hide()
--     else
--         awful.util.mymainmenu.active_child.wibox:connect_signal("mouse::leave",
--         function()
--             if awful.util.mymainmenu.wibox ~= mouse.current_wibox then
--                 awful.util.mymainmenu:hide()
--             end
--         end)
--     end
-- end)
-- 
-- -- Set the Menubar terminal for applications that require it
-- menubar.utils.terminal = terminal

-- Tag layout - Table of layouts to cover with awful.layout.inc, order matters.
tag.connect_signal("request::default_layouts", function()
    awful.layout.append_default_layouts({
        awful.layout.suit.floating,
        awful.layout.suit.tile,
        --awful.layout.suit.tile.left,
        awful.layout.suit.tile.bottom,
        --awful.layout.suit.tile.top,
        awful.layout.suit.fair,
        --awful.layout.suit.fair.horizontal,
        -- awful.layout.suit.spiral,
        -- awful.layout.suit.spiral.dwindle,
        awful.layout.suit.max,
        -- awful.layout.suit.max.fullscreen,
        -- awful.layout.suit.magnifier,
        -- awful.layout.suit.corner.nw,
        -- awful.layout.suit.corner.ne,
        -- awful.layout.suit.corner.sw,
        -- awful.layout.suit.corner.se,
    })
end)
 
-- Wibox Widget Bar Settings
local seperator = wibox.widget.textbox("|")
seperator.font = "Terminess Nerd Font 30"

-- Default widgets
-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- Create a textclock widget
mytextclock = wibox.widget.textclock("%l:%M %p")

screen.connect_signal("request::desktop_decoration", function(s)
    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[2])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()

    -- Create an imagebox widget which will contain an icon indicating which layout we're using. We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox {
        screen  = s,
        buttons = {
            awful.button({ }, 1, function () awful.layout.inc( 1) end),
            awful.button({ }, 3, function () awful.layout.inc(-1) end),
            awful.button({ }, 4, function () awful.layout.inc(-1) end),
            awful.button({ }, 5, function () awful.layout.inc( 1) end),
        }
    }

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = {
            awful.button({ }, 1, function(t) t:view_only() end),
            awful.button({ modkey }, 1, function(t)
                                            if client.focus then
                                                client.focus:move_to_tag(t)
                                            end
                                        end),
            awful.button({ }, 3, awful.tag.viewtoggle),
            awful.button({ modkey }, 3, function(t)
                                            if client.focus then
                                                client.focus:toggle_tag(t)
                                            end
                                        end),
            awful.button({ }, 4, function(t) awful.tag.viewprev(t.screen) end),
            awful.button({ }, 5, function(t) awful.tag.viewnext(t.screen) end),
        }
    }

    -- Create a tasklist widget
    --s.mytasklist = awful.widget.tasklist {
    --    screen  = s,
    --    filter  = awful.widget.tasklist.filter.currenttags,
    --    buttons = {
    --        awful.button({ }, 1, function (c)
    --            c:activate { context = "tasklist", action = "toggle_minimization" }
    --        end),
    --        --awful.button({ }, 3, function() awful.menu.client_list { theme = { width = 250 } } end),
    --        awful.button({ }, 4, function() awful.client.focus.byidx(-1) end),
    --        awful.button({ }, 5, function() awful.client.focus.byidx( 1) end),
    --    }
    --}

    -- Create the wibox
    s.mywibox = awful.wibar {
        position = "top",
        screen   = s,
        height = 24,
        --width = 1920,
        widget   = {
            layout = wibox.layout.align.horizontal,
            { -- Left widgets
                layout = wibox.layout.fixed.horizontal,
                --mylauncher,
                s.mytaglist,
                --s.mypromptbox,
            },
            s.mytasklist, -- Middle widget
            { -- Right widgets
                layout = wibox.layout.fixed.horizontal,
                mykeyboardlayout,
                seperator,
                wibox.widget.systray(),
                seperator,
                mytextclock,
                seperator,
                s.mylayoutbox,
            },
        }
    }
end)

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

awful.keyboard.append_global_keybindings({
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),

    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),

    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    --awful.key({ modkey }, "x",
    --          function ()
    --              awful.prompt.run {
    --                prompt       = "Run Lua code: ",
    --                textbox      = awful.screen.focused().mypromptbox.widget,
    --                exe_callback = awful.util.eval,
    --                history_path = awful.util.get_cache_dir() .. "/history_eval"
    --              }
    --          end,
    --          {description = "lua execute prompt", group = "awesome"}),

    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),

    awful.key({ }, "XF86AudioPlay", function () awful.spawn("playerctl play-pause") end,                         -- Play/Pause Track
              {description = "play/pause track", group = "hotkeys"}),

    awful.key({ }, "XF86AudioStop", function () awful.spawn("playerctl stop") end,                               -- Stop Track
              {description = "stop track", group = "hotkeys"}),

    awful.key({ }, "XF86AudioPrev", function () awful.spawn("playerctl prev") end,                               -- Previous Track
              {description = "previous track", group = "hotkeys"}),

    awful.key({ }, "XF86AudioNext", function () awful.spawn("playerctl next") end,                               -- Next track
              {description = "next track", group = "hotkeys"}),

    awful.key({ modkey }, "e", function () awful.spawn(terminal .. " -e bash -ic ranger") end,                   -- launch ranger file explorer
              {description = "launch ranger file explorer", group = "launcher"}),

    awful.key({ modkey }, "w", function () awful.spawn(browser) end,                                             -- launch browser
              {description = "run firefox browser", group = "launcher"}),

    awful.key({ altkey }, "space", function () awful.spawn.with_shell("rofi -show drun") end,                    -- spawn rofi menu
              {description = "start rofi launcher", group = "launcher"}),

    --awful.key({ modkey }, "r", function () awful.spawn.with_shell("rofi -show run -theme dmenu") end,            -- spawn rofi in dmenu mode
    --           {description = "start rofi dmenu launcher", group = "launcher"}),

    --awful.key({ modkey }, "i", function () awful.spawn.with_shell("fixtouchpad.sh") end,                         -- Toggle touchpad on/off
    --          {description = "toggle touchpad on/off", group = "hotkeys"}),

    awful.key({ }, "XF86MonBrightnessUp", function () awful.spawn.with_shell("brightnessctl set +10%") end,      -- Increase Brightness by 10%
              {description = "+10%", group = "hotkeys"}),

    awful.key({ }, "XF86MonBrightnessDown", function () awful.spawn.with_shell("brightnessctl set 10%-") end,    -- Decrease Brightness by 10%
              {description = "-10%", group = "hotkeys"}),

    awful.key({ altkey }, "XF86MonBrightnessDown", function () awful.spawn.with_shell("sleep 1; xset dpms force off") end,    -- Decrease Brightness by 10%
              {description = "off", group = "hotkeys"}),

    awful.key({ altkey, "Shift" }, "s", function () awful.spawn.with_shell("maim -sum 10 -f png | tee ~/Pictures/Screenshots/$(date +%s).jpg | xclip -selection clipboard -t image/png -i") end,      
              {description = "screenshot selection", group = "hotkeys"}),                                        -- Screenshot the selection, save to file and clipboard

    awful.key({ }, "Print", function () awful.spawn.with_shell("maim -um 10 -f png | tee ~/Pictures/Screenshots/$(date +%s).png | xclip -selection clipboard -t image/png -i") end,                      
              {description = "screenshot screen", group = "hotkeys"}),                                           -- Screenshot the screen, save to file and clipboard

    awful.key({ altkey }, "Print", function () awful.spawn.with_shell("maim -ust 9999999 -m 10 | tee ~/Pictures/Screenshots/$(date +%s).png | xclip -selection clipboard -t image/png -i") end,                     
              {description = "screenshot window", group = "hotkeys"}),                                           -- Screenshot the window, save to file and clipboard

    awful.key({ modkey, "Shift" }, "s", function () awful.spawn.with_shell("maim -sum 10 -f png | xclip -selection clipboard -t image/png -i") end,
              {description = "screenshot selection without save", group = "hotkeys"}),                           -- Screenshot the selection and send to clipboard

    --awful.key({ altkey }, "t", function () awful.spawn.with_shell( "variety -t" ) end,                           -- Wallpaper trash
    --          {description = "Wallpaper trash", group = "hotkeys"}),

    --awful.key({ altkey }, "n", function () awful.spawn.with_shell( "variety -n" ) end,                           -- Wallpaper next
    --          {description = "Wallpaper next", group = "hotkeys"}),

    --awful.key({ altkey }, "p", function () awful.spawn.with_shell( "variety -p" ) end,                           -- Wallpaper previous
    --          {description = "Wallpaper previous", group = "hotkeys"}),               

    --awful.key({ altkey }, "f", function () awful.spawn.with_shell( "variety -f" ) end,                           -- Wallpaper favorite
    --          {description = "Wallpaper favorite", group = "hotkeys"}),
              
    --awful.key({ altkey }, "Up", function () awful.spawn.with_shell( "variety --pause" ) end,                     -- Wallpaper pause
    --          {description = "Wallpaper pause", group = "hotkeys"}),
              
    --awful.key({ altkey }, "Down", function () awful.spawn.with_shell( "variety --resume" ) end,                  -- Wallpaper resume
    --          {description = "Wallpaper resume", group = "hotkeys"}),

    --awful.key({ altkey, "Shift"   }, "t", function () awful.spawn.with_shell( "variety -t  && wal -i $(cat $HOME/.config/variety/wallpaper/wallpaper.jpg.txt)&" ) end,
    --          {description = "Pywal Wallpaper trash", group = "hotkeys"}),

    --awful.key({ altkey, "Shift"   }, "n", function () awful.spawn.with_shell( "variety -n  && wal -i $(cat $HOME/.config/variety/wallpaper/wallpaper.jpg.txt)&" ) end,
    --          {description = "Pywal Wallpaper next", group = "hotkeys"}),

    --awful.key({ altkey, "Shift"   }, "u", function () awful.spawn.with_shell( "wal -i $(cat $HOME/.config/variety/wallpaper/wallpaper.jpg.txt)&" ) end,
    --          {description = "Pywal Wallpaper update", group = "hotkeys"}),

    --awful.key({ altkey, "Shift"   }, "p", function () awful.spawn.with_shell( "variety -p  && wal -i $(cat $HOME/.config/variety/wallpaper/wallpaper.jpg.txt)&" ) end,
    --          {description = "Pywal Wallpaper previous", group = "hotkeys"}),

    awful.key({ modkey,           }, "l", function () awful.spawn.with_shell("ff-lock.sh") end,                               -- lock screen with i3lock script
              {description = "run i3lock script", group = "hotkeys"}),             

    awful.key({ modkey }, "p", function() awful.spawn.with_shell("compositortoggle.sh") end,                            -- disable/enable compositor
              {description = "Toggle compositor", group = "hotkeys"}),

    awful.key({ modkey }, "b", function () for s in screen do                                                      -- Show/hide wibox
        s.mywibox.visible = not s.mywibox.visible
            if s.mybottomwibox then
                s.mybottomwibox.visible = not s.mybottomwibox.visible
            end
        end
    end,
        {description = "toggle wibox", group = "awesome"}),

})

-- Tags related keybindings
awful.keyboard.append_global_keybindings({
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),

    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),

    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),
})

-- Focus related keybindings
awful.keyboard.append_global_keybindings({
    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),

    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),

    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),

    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
              
    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:activate { raise = true, context = "key.unminimize" }
                  end
              end,
              {description = "restore minimized", group = "client"}),
})

-- Layout related keybindings
awful.keyboard.append_global_keybindings({
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    --awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
    --          {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),
})

awful.keyboard.append_global_keybindings({
    awful.key {
        modifiers   = { modkey },
        keygroup    = "numrow",
        description = "only view tag",
        group       = "tag",
        on_press    = function (index)
            local screen = awful.screen.focused()
            local tag = screen.tags[index]
            if tag then
                tag:view_only()
            end
        end,
    },
    awful.key {
        modifiers   = { modkey, "Control" },
        keygroup    = "numrow",
        description = "toggle tag",
        group       = "tag",
        on_press    = function (index)
            local screen = awful.screen.focused()
            local tag = screen.tags[index]
            if tag then
                awful.tag.viewtoggle(tag)
            end
        end,
    },
    awful.key {
        modifiers = { modkey, "Shift" },
        keygroup    = "numrow",
        description = "move focused client to tag",
        group       = "tag",
        on_press    = function (index)
            if client.focus then
                local tag = client.focus.screen.tags[index]
                if tag then
                    client.focus:move_to_tag(tag)
                end
            end
        end,
    },
    awful.key {
        modifiers   = { modkey, "Control", "Shift" },
        keygroup    = "numrow",
        description = "toggle focused client on tag",
        group       = "tag",
        on_press    = function (index)
            if client.focus then
                local tag = client.focus.screen.tags[index]
                if tag then
                    client.focus:toggle_tag(tag)
                end
            end
        end,
    },
    awful.key {
        modifiers   = { modkey },
        keygroup    = "numpad",
        description = "select layout directly",
        group       = "layout",
        on_press    = function (index)
            local t = awful.screen.focused().selected_tag
            if t then
                t.layout = t.layouts[index] or t.layout
            end
        end,
    }
})

client.connect_signal("request::default_mousebindings", function()
    awful.mouse.append_client_mousebindings({
        awful.button({ }, 1, function (c)
            c:activate { context = "mouse_click" }
        end),
        awful.button({ modkey }, 1, function (c)
            c:activate { context = "mouse_click", action = "mouse_move"  }
        end),
        awful.button({ modkey }, 3, function (c)
            c:activate { context = "mouse_click", action = "mouse_resize"}
        end),
    })
end)

client.connect_signal("request::default_keybindings", function()
    awful.keyboard.append_client_keybindings({
        awful.key({ modkey,           }, "f",
            function (c)
                c.fullscreen = not c.fullscreen
                c:raise()
            end,
            {description = "toggle fullscreen", group = "client"}),
        awful.key({ modkey }, "q",      function (c) c:kill()                         end,
                {description = "close", group = "client"}),
        awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
                {description = "toggle floating", group = "client"}),
        awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
                {description = "move to master", group = "client"}),
        awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
                {description = "move to screen", group = "client"}),
        awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
                {description = "toggle keep on top", group = "client"}),
        awful.key({ modkey,           }, "n",
            function (c)
                -- The client currently has the input focus, so it cannot be minimized, since minimized clients can't have the focus.
                c.minimized = true
            end ,
            {description = "minimize", group = "client"}),
        awful.key({ modkey,           }, "m",
            function (c)
                c.maximized = not c.maximized
                c:raise()
            end ,
            {description = "(un)maximize", group = "client"}),
        awful.key({ modkey, "Control" }, "m",
            function (c)
                c.maximized_vertical = not c.maximized_vertical
                c:raise()
            end ,
            {description = "(un)maximize vertically", group = "client"}),
        awful.key({ modkey, "Shift"   }, "m",
            function (c)
                c.maximized_horizontal = not c.maximized_horizontal
                c:raise()
            end ,
            {description = "(un)maximize horizontally", group = "client"}),
    })
end)

-- Mouse bindings
awful.mouse.append_global_mousebindings({
    --awful.button({ }, 3, function () awful.util.mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewprev),
    awful.button({ }, 5, awful.tag.viewnext),
})

-- Window Rules
-- Rules to apply to new clients.
ruled.client.connect_signal("request::rules", function()
    -- All clients will match this rule.
    ruled.client.append_rule {
        id         = "global",
        rule       = { },
        properties = {
            focus     = awful.client.focus.filter,
            raise     = true,
            screen    = awful.screen.preferred,
            placement = awful.placement.no_overlap+awful.placement.no_offscreen+awful.placement.centered,
            size_hints_honor = false -- Enabled to fix term spacing in xterm/urxvt etc
        }
    }

    -- Floating clients.
    ruled.client.append_rule {
        id       = "floating",
        rule_any = {
            instance = { "copyq", "pinentry" },
	    class    = {
                "Arandr", "Blueman-manager", "Gpick", "Kruler", "Sxiv",
                "Tor Browser", "Wpa_gui", "veromix", "xtightvncviewer"
            },
            -- Note that the name property shown in xprop might be set slightly after creation of the client and the name shown there might not match defined rules here.
            name    = {
                "Event Tester",  -- xev.
            },
            role    = {
                "AlarmWindow",    -- Thunderbird's calendar.
                "ConfigManager",  -- Thunderbird's about:config.
                "pop-up",         -- e.g. Google Chrome's (detached) Developer Tools.
            }
        },
        properties = { floating = true, placement = awful.placement.no_offscreen }
    }

    -- Add titlebars to normal clients and dialogs
    -- ruled.client.append_rule {
    --     id         = "titlebars",
    --     rule_any   = { type = { "normal", "dialog" } },
    --     properties = { titlebars_enabled = true      }
    -- }

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- ruled.client.append_rule {
    --     rule       = { class = "Firefox"     },
    --     properties = { screen = 1, tag = "2" }
    -- }
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = {
        awful.button({ }, 1, function()
            c:activate { context = "titlebar", action = "mouse_move"  }
        end),
        awful.button({ }, 3, function()
            c:activate { context = "titlebar", action = "mouse_resize"}
        end),
    }

    awful.titlebar(c).widget = {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                halign = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Notifications
--naughty = require("naughty")
--ruled.notification.connect_signal('request::rules', function()
--    -- All notifications will match this rule.
--    ruled.notification.append_rule {
--        rule       = { },
--        properties = {
--            screen           = awful.screen.preferred,
--            implicit_timeout = 5,
--        }
--    }
--end)
--
--naughty.connect_signal("request::display", function(n)
--    naughty.layout.box { notification = n }
--end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:activate { context = "mouse_enter", raise = false }
end)

-- Switch focus to urgent client automatically when link is called
client.connect_signal("property::urgent", function(c)
    if (c.class == "firefox") or (c.class == "discord") or (c.class == "alacritty") then
      awful.client.urgent.jumpto(false)
    end
end)

awful.spawn.with_shell("$HOME/.config/awesome/autostart.sh")

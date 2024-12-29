-- Widget Definitions
local lain  = require("lain")
local wibox = require("wibox")

local seperator = wibox.widget.textbox("|")
seperator.font = "Terminess Nerd Font 30"


-- Default widgets
-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- Create a textclock widget
mytextclock = wibox.widget.textclock("%l:%M %p")


--local st_logout_menu_widget = require("awesome-wm-widgets.logout-menu-widget.logout-menu") ({
--    font = beautiful.font,
--    onlogout = function() awesome.quit() end,
 --   onlock = function() awful.spawn.with_shell("ff-lock.sh") end,
 --   onreboot = function() awful.spawn.with_shell("reboot") end,
 --   onsuspend =	function() awful.spawn.with_shell("systemctl suspend") end,
 --   onpoweroff =function() awful.spawn.with_shell("poweroff") end,
--})

-- -- Lain widgets
-- lain_cal = lain.widget.cal({
--     attach_to = { mytextclock },
--     notification_preset = {
--         font = "Terminess Nerd Font Propo 12",
--         fg   = "#ffffff",
--         bg   = "#000000"
--     }
-- })

-- Lain RAM usage indicator
--local lain_ram = lain.widget.mem({
--    settings = function()
--        widget:set_markup("RAM: " .. mem_now.used .. " MB")
--    end
--})

-- Lain CPU usage indicator
--local lain_cpu_usage = lain.widget.cpu({
--    settings = function()
--        widget:set_markup("CPU: " .. cpu_now.usage .. "%")
--    end
--})

-- Coretemp
--local temp = lain.widget.temp({
--    settings = function()
--        widget:set_markup(coretemp_now .. "°C")
--    end
--})

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
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = {
            awful.button({ }, 1, function (c)
                c:activate { context = "tasklist", action = "toggle_minimization" }
            end),
            --awful.button({ }, 3, function() awful.menu.client_list { theme = { width = 250 } } end),
            awful.button({ }, 4, function() awful.client.focus.byidx(-1) end),
            awful.button({ }, 5, function() awful.client.focus.byidx( 1) end),
        }
    }

    -- Create the wibox
    s.mywibox = awful.wibar {
        position = "top",
        screen   = s,
        height = 20,
        --width = 1920,
        widget   = {
            layout = wibox.layout.align.horizontal,
            { -- Left widgets
                layout = wibox.layout.fixed.horizontal,
                --mylauncher,
                s.mytaglist,
                s.mypromptbox,
            },
            s.mytasklist, -- Middle widget
            { -- Right widgets
                layout = wibox.layout.fixed.horizontal,
                mykeyboardlayout,
                st_battery_widget,
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

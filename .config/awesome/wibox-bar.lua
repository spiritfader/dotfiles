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

-- StreetTurtle Widgets
local st_cpu_widget = require("awesome-wm-widgets.cpu-widget.cpu-widget") ({
    width = 70,
    step_width = 2,
    step_spacing = 0,
    color = '#434c5e'
})

local st_brightness_widget = require("awesome-wm-widgets.brightness-widget.brightness") ({
    type = 'icon_and_text',
    program = 'brightnessctl',
    step = '5',
    base = 20,
    path_to_icon = "/usr/share/icons/Arc/status/symbolic/display-brightness-symbolic.svg",
    font = beautiful.font,
    timeout	= 1,
    tooltip	= true,
    percentage = false,
    rmb_set_max	= false,
})

local st_battery_widget = require("awesome-wm-widgets.battery-widget.battery") ({
    font = beautiful.font,
    path_to_icons = "/usr/share/icons/Arc/status/symbolic/",
    show_current_level = true,
    margin_right = 0,
    margin_left = 0,
    display_notification = false,
    notification_position = top_right,
    timeout	= 10,
    warning_msg_title = "Houston, we have a problem",
    warning_msg_text = "Battery is dying",
    warning_msg_position = bottom_right,
    warning_msg_icon = "~/.config/awesome/awesome-wm-widgets/battery-widget/spaceman.jpg",
    enable_battery_warning = true,
})

local st_fs_widget = require("awesome-wm-widgets.fs-widget.fs-widget") ({
    mounts = { '/' },
    timeout = '60'
})

local st_ram_widget = require("awesome-wm-widgets.ram-widget.ram-widget") ({
    color_used = beautiful.bg_urgent,
    color_free = beautiful.fg_normal,
    color_buf = beautiful.border_color_active,
    widget_height = 25,
    widget_width = 25,
    widget_show_buf	= true,
    timeout = 1,
})

local st_logout_menu_widget = require("awesome-wm-widgets.logout-menu-widget.logout-menu") ({
    font = beautiful.font,
    onlogout = function() awesome.quit() end,
    onlock = function() awful.spawn.with_shell("ff-lock.sh") end,
    onreboot = function() awful.spawn.with_shell("reboot") end,
    onsuspend =	function() awful.spawn.with_shell("systemctl suspend") end,
    onpoweroff =function() awful.spawn.with_shell("poweroff") end,
})

-- local st_calendar_widget = require("awesome-wm-widgets.calendar-widget.calendar") ({
--     theme = 'outrun',
--     placement = 'top_right',
--     start_sunday = true,
--     radius = 8,
--     previous_month_button = 4,
--     next_month_button = 5,
-- })

-- mytextclock:connect_signal("button::press",
--     function(_, _, _, button)
--         if button == 1 then st_calendar_widget.toggle() end
--     end)

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
local lain_ram = lain.widget.mem({
    settings = function()
        widget:set_markup("RAM: " .. mem_now.used .. " MB")
    end
})

-- Lain CPU usage indicator
local lain_cpu_usage = lain.widget.cpu({
    settings = function()
        widget:set_markup("CPU: " .. cpu_now.usage .. "%")
    end
})

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
                seperator,
                st_logout_menu_widget,
                seperator,
                st_brightness_widget,
                seperator,
                st_battery_widget,
                --seperator,
                --st_fs_widget,
                seperator,
                lain_ram,
                --seperator,
                --lain_cpu_usage,
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

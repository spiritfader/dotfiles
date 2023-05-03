awful.keyboard.append_global_keybindings({
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),
    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),
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
    awful.key({ modkey }, "w", function () awful.spawn(browser) end,                                             -- launch Firefox
              {description = "run firefox browser", group = "launcher"}),
    awful.key({ altkey }, "space", function () awful.spawn.with_shell("rofi -show drun") end,                    -- spawn rofi menu
              {description = "start rofi launcher", group = "launcher"}),
    awful.key({ modkey }, "r", function () awful.spawn.with_shell("rofi -show run -theme dmenu") end,            -- spawn rofi in dmenu mode
               {description = "start rofi dmenu launcher", group = "launcher"}),
    awful.key({ modkey }, "i", function () awful.spawn.with_shell("fixtouchpad.sh") end,                      -- Toggle touchpad on/off
              {description = "toggle touchpad on/off", group = "hotkeys"}),
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
    awful.key({ altkey }, "t", function () awful.spawn.with_shell( "variety -t" ) end,                           -- Wallpaper trash
              {description = "Wallpaper trash", group = "hotkeys"}),
    awful.key({ altkey }, "n", function () awful.spawn.with_shell( "variety -n" ) end,                           -- Wallpaper next
              {description = "Wallpaper next", group = "hotkeys"}),
    awful.key({ altkey }, "p", function () awful.spawn.with_shell( "variety -p" ) end,                           -- Wallpaper previous
              {description = "Wallpaper previous", group = "hotkeys"}),               
    awful.key({ altkey }, "f", function () awful.spawn.with_shell( "variety -f" ) end,                           -- Wallpaper favorite
              {description = "Wallpaper favorite", group = "hotkeys"}),
    awful.key({ altkey }, "Up", function () awful.spawn.with_shell( "variety --pause" ) end,                     -- Wallpaper pause
              {description = "Wallpaper pause", group = "hotkeys"}),
    awful.key({ altkey }, "Down", function () awful.spawn.with_shell( "variety --resume" ) end,                  -- Wallpaper resume
              {description = "Wallpaper resume", group = "hotkeys"}),
    awful.key({ altkey, "Shift"   }, "t", function () awful.spawn.with_shell( "variety -t  && wal -i $(cat $HOME/.config/variety/wallpaper/wallpaper.jpg.txt)&" ) end,
              {description = "Pywal Wallpaper trash", group = "hotkeys"}),
    awful.key({ altkey, "Shift"   }, "n", function () awful.spawn.with_shell( "variety -n  && wal -i $(cat $HOME/.config/variety/wallpaper/wallpaper.jpg.txt)&" ) end,
              {description = "Pywal Wallpaper next", group = "hotkeys"}),
    awful.key({ altkey, "Shift"   }, "u", function () awful.spawn.with_shell( "wal -i $(cat $HOME/.config/variety/wallpaper/wallpaper.jpg.txt)&" ) end,
              {description = "Pywal Wallpaper update", group = "hotkeys"}),
    awful.key({ altkey, "Shift"   }, "p", function () awful.spawn.with_shell( "variety -p  && wal -i $(cat $HOME/.config/variety/wallpaper/wallpaper.jpg.txt)&" ) end,
              {description = "Pywal Wallpaper previous", group = "hotkeys"}),
    awful.key({ modkey, "Ctrl" }, "l", function () awful.spawn.with_shell("ff-lock.sh") end,                    -- lock screen with i3lock script
              {description = "run i3lock script", group = "hotkeys"}),              
    awful.key({ modkey }, "p", function() awful.spawn.with_shell("picomtoggle.sh") end,                         -- disable/enale compositor
              {description = "Toggle compositor", group = "hotkeys"}),

        -- Show/hide wibox
    awful.key({ modkey }, "b", function () for s in screen do
        s.mywibox.visible = not s.mywibox.visible
            if s.mybottomwibox then
                s.mybottomwibox.visible = not s.mybottomwibox.visible
            end
        end
    end,
        {description = "toggle wibox", group = "awesome"}),

-- Lain Keybinds

        -- Dynamic tagging
    awful.key({ modkey, "Shift" }, "n", function () lain.util.add_tag() end,
            {description = "add new tag", group = "tag"}),
    awful.key({ modkey, "Shift" }, "r", function () lain.util.rename_tag() end,
            {description = "rename tag", group = "tag"}),
    awful.key({ modkey, "Shift" }, "Left", function () lain.util.move_tag(-1) end,
            {description = "move tag to the left", group = "tag"}),
    awful.key({ modkey, "Shift" }, "Right", function () lain.util.move_tag(1) end,
            {description = "move tag to the right", group = "tag"}),
    awful.key({ modkey, "Shift" }, "d", function () lain.util.delete_tag() end,
            {description = "delete tag", group = "tag"}),

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
    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
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
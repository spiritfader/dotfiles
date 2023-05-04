---------------------------------------------------------------------------
--- SysRq hotkeys for awful.hotkeys_widget
--
-- @author spiritfader
-- @copyright 2023 spiritfader
-- @submodule awful.hotkeys_popup
---------------------------------------------------------------------------

local hotkeys_popup = require("awful.hotkeys_popup.widget")
for group_name, group_data in pairs({
    ["System Request (SysRq)"] = { color = "#02D2A0" }
}) do
    hotkeys_popup.add_group_rules(group_name, group_data)
end

local sysrq_keys = {
    ["SysRq"] = {{
        modifiers = { "Alt+fn+s, Alt" },
        keys = {
            h = "help",
            ["0..9"] = "loglevel(0-9)",
            b = "reboot",
            c = "crash",
            e = "terminate all tasks",
            f = "memory full oom kill",
            i = "kill all tasks",
            j = "thaw filesystems",
            k = "sak",
            l = "show backtrace all active cpus",
            m = "show memory usage",
            n = "nice all RT tasks",
            o = "poweroff",
            p = "show registers",
            q = "show all timers",
            r = "unraw",
            s = "sync",
            t = "show task states",
            u = "unmount",
            v = "force fb",
            w = "show blocked tasks",
            z = "dump ftrace buffer"
        }
    }},
}

hotkeys_popup.add_hotkeys(sysrq_keys)

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80

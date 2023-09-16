---------------------------------------
-- aure theme by spiritfader --
---------------------------------------

local theme_assets  = require("beautiful.theme_assets")
local xresources    = require("beautiful.xresources")
local rnotification = require("ruled.notification")
local dpi           = xresources.apply_dpi
local xrdb          = xresources.get_current_theme() -- for xresource pywal
local gfs           = require("gears.filesystem")
local themes_path   = ("~/.config/awesome/themes/")
local theme = {}
theme.font          = "Terminess Nerd Font Propo 12"

-- Set Colors from pywal generated xresource theme 
theme.bg_normal                = xrdb.background
theme.bg_focus                 = xrdb.color12
theme.bg_urgent                = xrdb.color9
theme.bg_minimize              = xrdb.color8
theme.bg_systray               = theme.bg_normal

theme.fg_normal                = xrdb.foreground
theme.fg_focus                 = theme.bg_normal
theme.fg_urgent                = theme.bg_normal
theme.fg_minimize              = theme.bg_normal

theme.useless_gap              = dpi(0)
theme.border_width             = dpi(1)
theme.border_color_normal      = xrdb.color0
theme.border_color_active      = theme.bg_focus
theme.border_color_marked      = xrdb.color10

-- theme.taglist_bg_focus         = ""
-- theme.taglist_bg_urgent        = ""
-- theme.taglist_bg_occupied      = ""
-- theme.taglist_bg_empty         = ""
-- theme.taglist_bg_volatile      = ""
-- 
-- theme.taglist_fg_focus         = ""
-- theme.taglist_fg_urgent        = ""
-- theme.taglist_fg_occupied      = ""
-- theme.taglist_fg_empty         = ""
-- theme.taglist_fg_volatile      = ""
-- 
-- theme.tasklist_bg_focus        = ""
-- theme.tasklist_bg_urgent       = ""
-- theme.tasklist_fg_focus        = ""
-- theme.tasklist_fg_urgent       = ""
-- 
-- theme.titlebar_bg_normal       = ""
-- theme.titlebar_bg_focus        = ""
-- theme.titlebar_fg_normal       = ""
-- theme.titlebar_fg_focus        = ""
-- 
-- theme.tooltip_font             = theme.font
-- theme.tooltip_opacity          = ""
theme.tooltip_fg_color         = theme.fg_normal
theme.tooltip_bg_color         = theme.bg_normal
-- theme.tooltip_border_width     = ""
-- theme.tooltip_border_color     = ""
-- 
-- theme.prompt_fg                = theme.fg_normal
-- theme.prompt_bg                = theme.bg_normal
-- theme.prompt_fg_cursor         = ""
-- theme.prompt_bg_cursor         = ""
-- theme.prompt_font              = theme.font
-- 
-- theme.hotkeys_bg               = ""
-- theme.hotkeys_fg               = ""
-- theme.hotkeys_border_width     = ""
-- theme.hotkeys_border_color     = ""
-- theme.hotkeys_shape            = ""
-- theme.hotkeys_opacity          = ""
-- theme.hotkeys_modifiers_fg     = ""
-- theme.hotkeys_label_bg         = ""
-- theme.hotkeys_label_bg         = ""
-- theme.hotkeys_group_margin     = ""
-- theme.hotkeys_font             = ""
-- theme.hotkeys_description_font = ""

-- Recolor Layout icons:
theme = theme_assets.recolor_layout(theme, theme.fg_normal)

-- Recolor Titlebar icons
local function darker(color_value, darker_n)
    local result = "#"
    for s in color_value:gmatch("[a-fA-F0-9][a-fA-F0-9]") do
        local bg_numeric_value = tonumber("0x"..s) - darker_n
        if bg_numeric_value < 0 then bg_numeric_value = 0 end
        if bg_numeric_value > 255 then bg_numeric_value = 255 end
        result = result .. string.format("%2.2x", bg_numeric_value)
    end
    return result
end

theme = theme_assets.recolor_titlebar(
    theme, theme.fg_normal, "normal"
)
theme = theme_assets.recolor_titlebar(
    theme, darker(theme.fg_normal, -60), "normal", "hover"
)
theme = theme_assets.recolor_titlebar(
    theme, xrdb.color1, "normal", "press"
)
theme = theme_assets.recolor_titlebar(
    theme, theme.fg_focus, "focus"
)
theme = theme_assets.recolor_titlebar(
    theme, darker(theme.fg_focus, -60), "focus", "hover"
)
theme = theme_assets.recolor_titlebar(
    theme, xrdb.color1, "focus", "press"
)

-- Generate taglist squares:
local taglist_square_size = dpi(4)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
    taglist_square_size, theme.fg_normal
)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    taglist_square_size, theme.fg_normal
)


-- layout icons
theme.layout_fairh      = themes_path.."aure/layouts/fairhw.png"
theme.layout_fairv      = themes_path.."aure/layouts/fairvw.png"
theme.layout_floating   = themes_path.."aure/layouts/floatingw.png"
theme.layout_magnifier  = themes_path.."aure/layouts/magnifierw.png"
theme.layout_max        = themes_path.."aure/layouts/maxw.png"
theme.layout_fullscreen = themes_path.."aure/layouts/fullscreenw.png"
theme.layout_tilebottom = themes_path.."aure/layouts/tilebottomw.png"
theme.layout_tileleft   = themes_path.."aure/layouts/tileleftw.png"
theme.layout_tile       = themes_path.."aure/layouts/tilew.png"
theme.layout_tiletop    = themes_path.."aure/layouts/tiletopw.png"
theme.layout_spiral     = themes_path.."aure/layouts/spiralw.png"
theme.layout_dwindle    = themes_path.."aure/layouts/dwindlew.png"
theme.layout_cornernw   = themes_path.."aure/layouts/cornernww.png"
theme.layout_cornerne   = themes_path.."aure/layouts/cornernew.png"
theme.layout_cornersw   = themes_path.."aure/layouts/cornersww.png"
theme.layout_cornerse   = themes_path.."aure/layouts/cornersew.png"

-- Define the icon theme for application icons. If not set then the icons from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = '/usr/share/icons/arc'

-- Set different colors for urgent notifications.
rnotification.connect_signal('request::rules', function()
    rnotification.append_rule {
        rule       = { urgency = 'critical' },
        properties = { bg = 'xrdb.background', fg = 'xrdb.foreground' }
    }
end)

return theme
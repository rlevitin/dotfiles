---------------------------
-- ZOLTAN theme --
---------------------------

theme = {}

theme.font          = "montecarlo 8"

theme.bg_normal     = "#070707"
theme.bg_focus      = "#070707"
theme.bg_urgent     = "#98afc7"
theme.bg_minimize   = "#444444"
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = "#ecedee"
theme.fg_focus      = "#6b8ba3"
theme.fg_urgent     = "#ecedee"
theme.fg_minimize   = "#ffffff"

theme.border_width  = "1"
theme.border_normal = "#070707"
theme.border_focus  = "#606060"
theme.border_marked = "#3ca4d8"
theme.border_urgent = "#070707"

theme.widget_net = "~/.config/awesome/icons/net_down_01.png"
theme.widget_netup = "~/.config/awesome/icons/net_up_01.png"
theme.widget_cpu = "~/.config/awesome/icons/cpu.png"
theme.widget_mem = "~/.config/awesome/icons/mem.png"
theme.widget_gmail = "~/.config/awesome/icons/mail.png"
theme.widget_pac = "~/.config/awesome/icons/pacman.png"
theme.widget_mpd = "~/.config/awesome/icons/note.png"
theme.widget_batt = "~/.config/awesome/icons/bat_full_01.png"
theme.widget_wifi = "~/.config/awesome/icons/wifi_03.png"
theme.widget_vol = "~/.config/awesome/icons/spkr_01.png"
theme.widget_temp = "~/.config/awesome/icons/temp.png"
theme.widget_play = "~/.config/awesome/icons/play.png"
theme.widget_pause = "~/.config/awesome/icons/pause.png"
theme.widget_stop = "~/.config/awesome/icons/stop.png"
theme.widget_prev = "~/.config/awesome/icons/prev.png"
theme.widget_next = "~/.config/awesome/icons/next.png"

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent]theme
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

-- Display the taglist squares
theme.taglist_squares_sel   = "/usr/share/awesome/themes/default/taglist/squarefw.png"
theme.taglist_squares_unsel = "/usr/share/awesome/themes/default/taglist/squarew.png"

theme.tasklist_floating_icon = "/usr/share/awesome/themes/default/tasklist/floatingw.png"

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = "~/.config/awesome/themes/Zoltan/submenu.png"
theme.menu_height = "17"
theme.menu_width  = "100"
theme.menu_fg_normal = "#ecedee"   
theme.menu_fg_focus =  "#6b8ba3"
theme.menu_bg_normal = "#000000aa"
theme.menu_bg_focus  = "#000000dd"
theme.menu_border_width = "0"

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
theme.titlebar_close_button_normal = "/usr/share/awesome/themes/default/titlebar/close_normal.png"
theme.titlebar_close_button_focus  = "/usr/share/awesome/themes/default/titlebar/close_focus.png"

theme.titlebar_ontop_button_normal_inactive = "/usr/share/awesome/themes/default/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive  = "/usr/share/awesome/themes/default/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = "/usr/share/awesome/themes/default/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active  = "/usr/share/awesome/themes/default/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = "/usr/share/awesome/themes/default/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive  = "/usr/share/awesome/themes/default/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = "/usr/share/awesome/themes/default/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active  = "/usr/share/awesome/themes/default/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = "/usr/share/awesome/themes/default/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive  = "/usr/share/awesome/themes/default/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = "/usr/share/awesome/themes/default/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active  = "/usr/share/awesome/themes/default/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = "/usr/share/awesome/themes/default/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = "/usr/share/awesome/themes/default/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = "/usr/share/awesome/themes/default/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active  = "/usr/share/awesome/themes/default/titlebar/maximized_focus_active.png"

-- You can use your own command to set your wallpaper
theme.wallpaper_cmd = { "feh --bg-scale '/home/ron/.wallpapers/current.jpg" }

-- You can use your own layout icons like this:
theme.layout_fairh = "~/.config/awesome/layouts/fairhw.png"
theme.layout_fairv = "~/.config/awesome/layouts/fairvw.png"
theme.layout_floating  = "~/.config/awesome/layouts/floatingw.png"
theme.layout_magnifier = "~/.config/awesome/layouts/magnifierw.png"
theme.layout_max = "~/.config/awesome/layouts/maxw.png"
theme.layout_fullscreen = "~/.config/awesome/layouts/fullscreenw.png"
theme.layout_tilebottom = "~/.config/awesome/layouts/tilebottomw.png"
theme.layout_tileleft   = "~/.config/awesome/layouts/tileleftw.png"
theme.layout_tile = "~/.config/awesome/layouts/tilew.png"
theme.layout_tiletop = "~/.config/awesome/layouts/tiletopw.png"
theme.layout_spiral  = "~/.config/awesome/layouts/spiralw.png"
theme.layout_dwindle = "~/.config/awesome/layouts/dwindlew.png"

theme.awesome_icon = "~/.config/awesome/themes/Zoltan/awesome16.png"

return theme
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80

-- ~/.config/awesome/rc.lua
-- Standard awesome library
local awful = require("awful")
local gears = require("gears")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Theme handling library
local beautiful = require("beautiful")
-- Notifications
local naughty = require("naughty")
local menubar = require("menubar")
-- Widgets and Layout
local wibox = require("wibox")
local vicious = require("vicious")

-- {{{ Variable definitions

-- This is used later as the default terminal to run.
terminal = "urxvtc"
editor = os.getenv("EDITOR") or "gvim"
editor_cmd = terminal .. " -e " .. editor
filemngr = terminal .. " -e ranger"
browser = "chromium"
exec = awful.util.spawn
home = os.getenv("HOME")

-- Themes define colours, icons, and wallpapers
beautiful.init(awful.util.getdir("config") .. "/themes/Zoltan/theme.lua")
-- beautiful.init(awful.util.getdir("config") .. "theme.lua")

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}

layouts =
{
    awful.layout.suit.floating,         -- 1
    awful.layout.suit.tile,             -- 2
    -- awful.layout.suit
    --.tile.left,        --
    awful.layout.suit.tile.bottom,      -- 3
    -- awful.layout.suit.tile.top,         --
    -- awful.layout.suit.fair,             -- 
    -- awful.layout.suit.fair.horizontal,  -- 
    -- awful.layout.suit.spiral,           -- 
    awful.layout.suit.spiral.dwindle,   -- 4 
    awful.layout.suit.max,              -- 5
    awful.layout.suit.max.fullscreen,   -- 6
--    awful.layout.suit.magnifier         -- 
}
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = { names = {"trm","web","doc","dev","med","oth"},
        layout = {layouts[2],layouts[5],layouts[2],layouts[2],layouts[2],layouts[2]}
}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag(tags.names, s, tags.layout)
end
-- }}}

-- {{{ Wibox

-- Seperators
spacer = wibox.widget.textbox()
seperator = wibox.widget.textbox()
dash = wibox.widget.textbox()
spacer:set_markup(" ")
seperator:set_markup("|")
dash:set_markup("-")

-- MPD icon
-- Icon is updated according to the current MPD status
-- see MPD textwidget below
mpdicon = wibox.widget.imagebox()
mpdicon:set_image(home .. "/.config/awesome/icons/note.png")

-- MPD textwidget
-- Initialize widget
mpdwidget = wibox.widget.textbox()
-- Register widget
vicious.register(mpdwidget, vicious.widgets.mpd,
    function (widget, args)
        if args["{state}"] == "Stop" then 
            mpdicon:set_image(home .. "/.config/awesome/icons/stop.png")
            return " "
        elseif args["{state}"] == "Pause" then
            mpdicon:set_image(home .. "/.config/awesome/icons/pause.png")
            return args["{Artist}"]..' - '.. args["{Title}"]
        elseif args["{state}"] == "Play" then
            mpdicon:set_image(home .. "/.config/awesome/icons/play.png")
            return args["{Artist}"]..' - '.. args["{Title}"]
        else
            mpdicon:set_image(home .. "/.config/awesome/icons/note.png")
            return "MPD status unknown"
        end
    end, 3)

-- Weather Widget
-- Initialize Widget
weatherwidget = wibox.widget.textbox()
-- Register Widget
-- Nuernberg: EDDN, Kuala Lumpur: WMKK
vicious.register(weatherwidget, vicious.widgets.weather, "${tempc}°", 500, "LLBG")

-- Volumewidget
volicon = wibox.widget.imagebox()
volicon:set_image(home .. "/.config/awesome/icons/spkr_01.png")
volwidget = wibox.widget.textbox()
vicious.register(volwidget, vicious.widgets.volume, " $1% ", 2, "Master")
-- Keybindings for widget
volwidget:buttons(awful.util.table.join(
    awful.button({ }, 1, function () exec("urxvt -e alsamixer") end),
    awful.button({ }, 2, function () exec("amixer set Master toggle")   end),
    awful.button({ }, 4, function () exec("amixer set Master 5%+", false) end),
    awful.button({ }, 5, function () exec("amixer set Master 5%-", false) end)
 )) -- amixer set Master 5%+

-- Wifiwidget
wifiwidget = wibox.widget.textbox()
vicious.register(wifiwidget, vicious.widgets.wifi, "${link}%", 5, "wlan0")

-- Memwidget
memicon = wibox.widget.imagebox()
memicon:set_image(home .. "/.config/awesome/icons/mem.png")
memwidget = wibox.widget.textbox()
vicious.register(memwidget, vicious.widgets.mem, "$1%", 3)


-- Create a battery widget
baticon = wibox.widget.imagebox()
baticon:set_image(home .. "/.config/awesome/icons/bat_full_01.png")
--Initialize widget
batwidget = wibox.widget.textbox()
--Register widget
vicious.register(batwidget, vicious.widgets.bat, "$1$2%", 32, "BAT0")

-- Create a textclock widget
mytextclock = awful.widget.textclock()

-- Create a wibox for each screen and add it
mywibox = {}
mygraphbox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
  awful.button({ }, 1, awful.tag.viewonly),
  awful.button({ modkey }, 1, awful.client.movetotag),
  awful.button({ }, 3, awful.tag.viewtoggle),
  awful.button({ modkey }, 3, awful.client.toggletag),
  awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
  awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
)
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
  awful.button({ }, 1, function(c)
      if c == client.focus then
        c.minimized = true
      else
        c.minimized = false
        if not c:isvisible() then
          awful.tag.viewonly(c:tags()[1])
        end
        client.focus = c
        c:raise()
      end
    end),
  awful.button({ }, 3, function()
      if instance then
        instance:hide()
        instance = nil
      else
        instance = awful.menu.clients({ width=250 })
      end
    end),
  awful.button({ }, 4, function()
      awful.client.focus.byidx(1)
      if client.focus then client.focus:raise() end
    end),
  awful.button({ }, 5, function()
      awful.client.focus.byidx(-1)
      if client.focus then client.focus:raise() end
    end))

for s = 1, screen.count() do
  mypromptbox[s] = awful.widget.prompt()

  -- Layoutbox
  mylayoutbox[s] = awful.widget.layoutbox(s)
  mylayoutbox[s]:buttons(awful.util.table.join(
      awful.button({ }, 1, function() awful.layout.inc(layouts, 1) end),
      awful.button({ }, 3, function() awful.layout.inc(layouts, -1) end),
      awful.button({ }, 4, function() awful.layout.inc(layouts, 1) end),
      awful.button({ }, 5, function() awful.layout.inc(layouts, -1) end)))

  -- Taglist
  mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

  -- Tasklist
  mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

  -- Create the wibox
  mywibox[s] = awful.wibox({ position = "top", screen = s })

  -- Widgets that are aligned to the left, order matters
  local left_layout = wibox.layout.fixed.horizontal()
  left_layout:add(mytaglist[s])
  left_layout:add(mypromptbox[s])

  -- Widgets that are aligned to the right, order matters
  local right_layout = wibox.layout.fixed.horizontal()
  right_layout:add(mpdicon)
  right_layout:add(spacer)
  right_layout:add(mpdwidget)
  right_layout:add(spacer)
  -- Weather
  right_layout:add(weatherwidget)
  right_layout:add(spacer)
  right_layout:add(seperator)
  -- Volumne
  right_layout:add(volicon)
  right_layout:add(volwidget)
  right_layout:add(spacer)
  right_layout:add(seperator)
  right_layout:add(spacer)
  -- Wifi
  right_layout:add(memicon)
  right_layout:add(memwidget)
  right_layout:add(spacer)
  right_layout:add(seperator)
  -- Battery
  right_layout:add(baticon)
  right_layout:add(batwidget)
  right_layout:add(spacer)
  right_layout:add(seperator)
  right_layout:add(spacer)
  -- Clock
  if s == 1 then right_layout:add(wibox.widget.systray()) end
  right_layout:add(mytextclock)
  right_layout:add(spacer)
  right_layout:add(seperator)
  -- Layout box
  right_layout:add(mylayoutbox[s])
  -- right_layout:add(spacer)

  -- Now bring it all together
  local layout = wibox.layout.align.horizontal()
  layout:set_left(left_layout)
  layout:set_middle(mytasklist[s])
  layout:set_right(right_layout)

  mywibox[s]:set_widget(layout)
end
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Brightness Keys
    awful.key({ }, "XF86MonBrightnessUp", function()
            exec("xbacklight +20% -steps 1")
        end),
    awful.key({ }, "XF86MonBrightnessDown", function()
            exec("xbacklight -20% -steps 1")
        end),

    -- Volume Keys
    awful.key({ }, "XF86AudioRaiseVolume", function ()
       exec("amixer set Master 5%+") end),
   awful.key({ }, "XF86AudioLowerVolume", function ()
       exec("amixer set Master 5%-") end),
   awful.key({ }, "XF86AudioMute", function ()
       exec("amixer set Master toggle") end),

    -- Standard programs
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey,		      }, "e", function () awful.util.spawn(filemngr) end),
    awful.key({ modkey,           }, "q", function() awful.util.spawn(browser) end),
	awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),
    
    -- Lock Screen
    awful.key({modkey,		  }, "F12",   function () awful.util.spawn("xautolock -locknow") end),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),
    -- dmenu
    awful.key({ modkey, },        "p", function () 
        -- exec("dmenu_run -b -fn '" .. beautiful.font .. "' -nb '" .. beautiful.bg_normal .. "' -nf '" .. beautiful.fg_normal .. "' -sb '" .. beautiful.bg_focus .. "' -sf '" .. beautiful.fg_focus .. "'")
		exec("dmenu_run -b")
	end),
  awful.key({ modkey,           }, "t",   function () exec("thunar") end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey,           }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digits we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}
-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
		     size_hints_honor = false,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    -- 1: term
    
    -- 2: web
     { rule = { class = "Firefox" },
      properties = { tag = tags[mouse.screen][2], maximized_vertical = true, maximized_horizontal = true, switchtotag = true } },
     { rule = { class = "Luakit" },
      properties = { tag = tags[mouse.screen][2], maximized_vertical = true, maximized_horizontal = true, switchtotag = true } },
     { rule = { class = "Chromium" },
      properties = { tag = tags[mouse.screen][2], maximized_vertical = true, maximized_horizontal = true, switchtotag = true } },
      
    -- 3: docs
    { rule = { class = "Zathura" },
      properties = { tag = tags[mouse.screen][3], switchtotag = true } },
    { rule = { class = "libreoffice-calc" },
      properties = { tag = tags[mouse.screen][3], switchtotag = true } },
    { rule = { class = "libreoffice-writer" },
      properties = { tag = tags[mouse.screen][3], switchtotag = true } },
    { rule = { class = "libreoffice-impress" },
      properties = { tag = tags[mouse.screen][3], switchtotag = true } },

    -- 4: dev
    { rule = { class = "Gvim" },
      properties = { tag = tags[mouse.screen][4], switchtotag = true } },
    { rule = { class = "Eclipse" },
      properties = { tag = tags[mouse.screen][4], switchtotag = true } },

    -- 5: media
    { rule = { class = "MPlayer" },
      properties = { tag = tags[mouse.screen][5], switchtotag = true, floating = true } },
    { rule = { class = "Vlc" },
      properties = { tag = tags[mouse.screen][5], switchtotag = true, floating = true } },
    { rule = { class = "Gimp" },
      properties = { tag = tags[mouse.screen][5], switchtotag = true, floating = true } },
    { rule = { class = "Deluge" },
      properties = { tag = tags[mouse.screen][5], switchtotag = true } },

    -- 6: other
    { rule = { class = "Wicd-client.py" },
      properties = { tag = tags[mouse.screen][6], floating = true, switchtotag = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local title = awful.titlebar.widget.titlewidget(c)
        title:buttons(awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                ))

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(title)

        awful.titlebar(c):set_widget(layout)
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

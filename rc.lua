-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")
-- Widgets
require("vicious")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.add_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- alias
-- [[
userdir = "/home/ron/"
exec = awful.util.spawn
sexec = awful.util.spawn_with_shell
--]]
-- theme
beautiful.init(userdir .. ".config/awesome/themes/Zoltan/theme.lua")
-- std programs
terminal = "urxvtc"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor
guieditor = "gvim"
browser = "luakit"
fm = "thunar"


-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.floating,         -- 1
    awful.layout.suit.tile,             -- 2
    -- awful.layout.suit.tile.left,        --
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

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}
myeditorsmenu = {
   { "gvim", function () exec(gvim) end },
   { "inkscape", function () exec(inkscape) end},
   { "libreoffice", function () exec(libreoffice) end}
}
mymediamenu = {
   { "music", terminal .. " -e ncmpcpp" },
   { "mirage", function () exec(mirage) end } 
}
mywebmenu = {
   { "luakit", function () exec(luakit) end },
   { "firefox", function () exec(firefox) end },
   { "IRC", terminal .. "-e irssi" },
   { "youtube", terminal ..  " -e youtube-viewer" },
   { "wicd", function () sexec("wicd-gtk") end }
}
myfoldersmenu = {
   { "Home", function () exec(fm .. " " ..  userdir) end },
   { "Downloads", function () exec(fm .. " " .. userdir .. "Downloads") end},
   { "Not Yet Watched", function () exec(fm .. " '" .. userdir .. "deluge/Not Yet Watched'") end},
   { "Books", function () exec(fm .. " " .. userdir .. "Books") end},
   { "Movies", function () exec(fm .. " " .. userdir .. "Movies") end},
   { "TV", function () exec(fm .. " " .. userdir .. "TV") end},
   { "Dropbox", function () exec(fm .. " " ..  userdir .. "Dropbox") end },
   { "Documents", function () exec(fm .. " " ..  userdir .. "Documents") end } 
}
mysystemmenu = {
    { "Shutdown", function () sexec("poweroff") end },
    { "Reboot", function () sexec("reboot") end },
    { "Lock", function () sexec("slimlock") end }

}
mymainmenu = awful.menu( { items = {
                         { "Awesome", myawesomemenu },
                         { "Editors", myeditorsmenu },
                         { "Media", mymediamenu },
                         { "Web", mywebmenu }, 
                         { "Folders", myfoldersmenu },
                         { "System", mysystemmenu }
}
})

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = mymainmenu })
-- }}}

-- {{{ Wibox
--[[
    Definitions for all the widgets.
    - Weather widget
    - Calendar widget
    - Temperature widget
    - Gmail widget
    - Pacman widget
    - CPU widget
    - Battery widget
    - Volume widget
    - Memory widget
    - MPD widget
--]]
-- Weather widget
weatherwidget = widget({ type = "textbox" })
weather_t = awful.tooltip({ objects = { weatherwidget },})

vicious.register(weatherwidget, vicious.widgets.weather,
                function (widget, args)
                    weather_t:set_text("City: " .. args["{city}"] .."\nWind: " .. args["{windkmh}"] .. " km/h " .. args["{wind}"] .. "\nSky: " .. args["{sky}"] .. "\nHumidity: " .. args["{humid}"] .. "%")
                    return args["{tempc}"] .. "C"
                end, 3600, "LLBG")
                --'1800': check every 30 minutes.
                --'CYUL': the Montreal ICAO code.


-- Create a textclock widget
mytextclock = awful.widget.textclock({ align = "right"}," %a %b %d, %I:%M%P ")
-- Calendar widget to attach to the textclock
require('calendar2')
calendar2.addCalendarToWidget(mytextclock)

-- CPU Icon
cpuicon = widget({ type = "imagebox" })
cpuicon.image = image(beautiful.widget_cpu)
-- CPU Widget 
cpubar = widget({ type = "textbox" })
vicious.register(cpubar, vicious.widgets.cpu, "CPU0: $2% CPU1:$3%", 7)

-- MEM icon
memicon = widget ({type = "imagebox" })
memicon.image = image(beautiful.widget_mem)
-- Mem widget
membar = widget({ type = "textbox" })
vicious.register(membar, vicious.widgets.mem, "$1%", 13)

-- BATT Icon
baticon = widget ({type = "imagebox" })
baticon.image = image(beautiful.widget_batt)
-- Initialize BATT widget
batwidget = widget({ type = "textbox" })
vicious.register(batwidget, vicious.widgets.bat,
                function (widget, args)
                    if args[1] == "+" or args[1] == "-" then
                        return string.format("%02d%% (%s%s)", args[2], args[1], args[3])
                    else
                        return args[1]
                    end
                end, 60, "BAT0")
                
-- Vol Icon
volicon = widget ({type = "imagebox" })
volicon.image = image(beautiful.widget_vol)
-- Vol bar Widget
volbar = widget({ type = "textbox" })
vicious.register(volbar, vicious.widgets.volume,  "$2$1%",  1, "Master")

-- Temp Icon
tempicon = widget({ type = "imagebox" })
tempicon.image = image(beautiful.widget_temp)
-- Temp Widget
tempwidget = widget({ type = "textbox" })
vicious.register(tempwidget, vicious.widgets.thermal, "$1°C", 9, {"coretemp.0", "core"})


--[[ Gmail Widget and Tooltip
mygmail = widget({ type = "textbox" })
gmail_t = awful.tooltip({ objects = { mygmail },})

mygmailimg = widget({ type = "imagebox" })
mygmailimg.image = image(beautiful.widget_gmail)

vicious.register(mygmail, vicious.widgets.gmail,
                function (widget, args)
                    gmail_t:set_text(args["{subject}"])
                    gmail_t:add_to_object(mygmailimg)
                    return args["{count}"]
                 end, 241) ]]--
                 
-- Pacman Icon
pacicon = widget({type = "imagebox" })
pacicon.image = image(beautiful.widget_pac)
-- Pacman Widget
pacwidget = widget({type = "textbox"})
pacwidget_t = awful.tooltip({ objects = { pacwidget},})
vicious.register(pacwidget, vicious.widgets.pkg, "$1", 93, "Arch")

-- MPD Icon
mpdicon = widget({ type = "imagebox" })
mpdicon.image = image(beautiful.widget_mpd)
-- Initialize MPD Widget
mpdwidget = widget({ type = "textbox" })
vicious.register(mpdwidget, vicious.widgets.mpd,
    function (widget, args)
        if args["{state}"] == "Stop" then 
            return " - "
        else 
            return args["{Artist}"]..' - '.. args["{Title}"]
        end
    end, 10)

-- Spacers
rbracket = widget({type = "textbox" })
rbracket.text = "]"
lbracket = widget({type = "textbox" })
lbracket.text = "["

-- Space
space = widget({ type = "textbox" })
space.text = " "

-- MPD controls
music_play = awful.widget.launcher({
    image = beautiful.widget_play,
    command = "ncmpcpp toggle && echo -e 'vicious.force({ mpdwidget, })' | awesome-client"
  })

  music_pause = awful.widget.launcher({
    image = beautiful.widget_pause,
    command = "ncmpcpp toggle && echo -e 'vicious.force({ mpdwidget, })' | awesome-client"
  })
  music_pause.visible = false

  music_stop = awful.widget.launcher({
    image = beautiful.widget_stop,
    command = "ncmpcpp stop && echo -e 'vicious.force({ mpdwidget, })' | awesome-client"
  })

  music_prev = awful.widget.launcher({
    image = beautiful.widget_prev,
    command = "ncmpcpp prev && echo -e 'vicious.force({ mpdwidget, })' | awesome-client"
  })

  music_next = awful.widget.launcher({
    image = beautiful.widget_next,
    command = "ncmpcpp next && echo -e 'vicious.force({ mpdwidget, })' | awesome-client"
  })

-- Create a systray
mysystray = widget({ type = "systray" })

-- Create a wibox for each screen and add it
mywibox = {}
mybottomwibox = {}
mystatusbar = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(function(c)
                                              return awful.widget.tasklist.label.currenttags(c, s)
                                          end, mytasklist.buttons)

    -- Create the upper wibox, then add widgets to the wibox - order matters
    mywibox[s] = awful.wibox({ position = "top", screen = s })
    mywibox[s].widgets = {
        {
            mylauncher,
            mytaglist[s],
            mypromptbox[s],
            layout = awful.widget.layout.horizontal.leftright
        },
        mylayoutbox[s],
	    mytextclock,
        weatherwidget,
        space,
        s == 1 and mysystray or nil,
        mytasklist[s],
        layout = awful.widget.layout.horizontal.rightleft
    }
     
    -- Create the bottom wibox, then add widgets to the box
    mybottomwibox[s] = awful.wibox({ position = "bottom", screen = s, border_width = 0, height = 16 })
    mybottomwibox[s].widgets = {
    {
        space, lbracket, space, cpuicon, space, cpubar, space, rbracket, 
        space, lbracket, space, memicon, space, membar, space, rbracket, 
        space, lbracket, space, baticon, space, batwidget, space, rbracket,
        space, lbracket, space, volicon, space, volbar, space, rbracket,
        layout = awful.widget.layout.horizontal.leftright
    },
        space,rbracket, space, tempwidget, space, tempicon, space, lbracket,
        space, rbracket, space, pacwidget, pacicon, space, lbracket,
        --space, rbracket, space, mygmail, space, mygmailimg, space, lbracket,
        space, rbracket, space, music_stop, music_pause, music_play, music_next, music_prev, space, mpdwidget, space, mpdicon, space, lbracket, 
        layout = awful.widget.layout.horizontal.rightleft
    }
end

-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
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
    awful.key({ modkey,           }, "w", function () mymainmenu:show({keygrabber=true}) end),

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

    -- Standard program
    awful.key({ modkey,           }, "Return", function () exec(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    -- awful.key({ modkey,  "Shift"  }, "l",     function () awful.client.incwfact( 0.05)    end),
    -- awful.key({ modkey,  "Shift"  }, "h",     function () awful.client.incwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

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
    awful.key({ "Control" },        "space", function () 
        exec("dmenu_run -b -fn '" .. beautiful.font .. "' -nb '" .. beautiful.bg_normal .. "' -nf '" .. beautiful.fg_normal .. "' -sb '" .. beautiful.bg_focus .. "' -sf '" .. beautiful.fg_focus .. "'")
        -- awful.util.spawn("dmenu_run -b")
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
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
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

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
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
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })

	
	-- -- put this in your "manage" signal handler
    -- c:add_signal("property::urgent", function(c)
	-- 	if c.urgent then
	-- 		-- Change the border color of the urgent window.
	-- 		-- You'll need to define the color in your theme.lua, e.g.
	-- 		-- theme.border_urgent = "#FF3737CC"
	-- 		-- or you set the color directly to c.border_color 
	-- 		c.border_color = beautiful.border_urgent

	-- 		-- Show a popup notification with the window title
	-- 		naughty.notify({text="Urgent: " .. c.name})
	-- 	end
	-- end)
	

    -- Enable sloppy focus
    c:add_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
         awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

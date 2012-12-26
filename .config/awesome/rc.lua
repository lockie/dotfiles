
city = "dubna"
home = os.getenv("HOME")

-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")

vicious = require("vicious")
require("vicious.widgets.os")
require("vicious.widgets.uptime")
require("vicious.widgets.thermal")
require("vicious.widgets.fan")
require("vicious.widgets.nvidiatemp")
require("vicious.widgets.cpufreq")
require("vicious.widgets.top")
require("vicious.widgets.net")
require("vicious.widgets.fs")
require("vicious.widgets.dio")
require("vicious.widgets.hddtemp")
require("vicious.widgets.gmail")
require("vicious.widgets.volume")

require("weather")
require("calendar2")


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
-- Themes define colours, icons, and wallpapers
beautiful.init(home .. "/.config/awesome/themes/zenburn/theme.lua")
beautiful.awesome_icon = home .. "/.config/awesome/gentoo.png"
 
-- This is used later as the default terminal and editor to run.
terminal = "sakura"
editor = os.getenv("EDITOR") or "vi"
editor_cmd = "gvim"
browser = "firefox"
filemanager = "pcmanfm"

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
--    awful.layout.suit.floating, -- TODO : float custom window
--    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
--    awful.layout.suit.tile.top,
--    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
--    awful.layout.suit.spiral,
--    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max
--    awful.layout.suit.max.fullscreen,
--    awful.layout.suit.magnifier
}
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag({ "Default", "TODO", "Coding", "Internets" }, s, layouts[1]) -- TODO : icons instead of text?
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", awesome.quit },
   { "shutdown", home .. "/bin/shutdown_dialog.sh" }
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "firefox", "firefox" },
                                    { "pidgin", "/usr/bin/pidgin" },
                                    { "freemind", "/usr/bin/freemind" },
                                    { "terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = mymainmenu })
-- }}}

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock({ align = "right" }, "%H:%M:%S", 1)
calendar2.addCalendarToWidget(mytextclock, "<span color='green'>%s</span>")

-- Create a systray
mysystray = widget({ type = "systray" })

-- reusable separator
separator = widget({ type = "imagebox" })
separator.image = image(beautiful.widget_sep)

-- Create a wibox for each screen and add it
mywibox = {}
myindicators = {}
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

f = io.popen('cat /proc/cpuinfo | grep processor | wc -l')
core_count = f:read()
have_cpufreq=0
if os.execute("ls /sys/devices/system/cpu/cpu0/cpufreq &> /dev/null") == 0 then
    have_cpufreq=1
end
have_fan=0
if os.execute("ls /sys/devices/platform/it87.656/fan1_input &> /dev/null") == 0 then
    have_fan=1
end

weatherwidget = widget({ type = "textbox" })
weather.addWeather(weatherwidget, city, 600)

ind_os = widget({ type = "textbox" })
vicious.register(ind_os, vicious.widgets.os, "$4<span color='#7F9F7F'><b>@</b></span>$2")
ind_os.width = 160
ind_uptime = widget({ type = "textbox" })
ind_uptime.width = 90
vicious.register(ind_uptime, vicious.widgets.uptime,
  '<span color="#7F9F7F"><b>↑</b></span>$1d $2h $3m')
ind_cpu1 = widget({ type = "textbox" })
vicious.register(ind_cpu1, vicious.widgets.cpu, "$1%", 1)
vicious.cache(vicious.widgets.cpu)
ind_cpu1.width = 25
ind_cpu1.align = 'right'
ind_cpuf1 = widget({ type = "textbox" })
if have_cpufreq==1 then
    vicious.register(ind_cpuf1, vicious.widgets.cpufreq, "<b><span color='#7F9F7F'>⌚</span></b><span color='#7f7f7f'>$2</span>", 1, "cpu0")
    ind_cpuf1.width = 40
else
    ind_cpuf1.width = 10
end
ind_cpu2 = widget({ type = "textbox" })
vicious.register(ind_cpu2, vicious.widgets.cpu, "$2%", 1)
ind_cpu2.width = 25
ind_cpu2.align = 'right'
ind_cpuf2 = widget({ type = "textbox" })
if have_cpufreq==1 then
    vicious.register(ind_cpuf2, vicious.widgets.cpufreq, "<b><span color='#7F9F7F'>⌚</span></b><span color='#7f7f7f'>$2</span>", 1, "cpu1")
    ind_cpuf2.width = 40
else
    ind_cpuf1.width = 10
end
if core_count == '4' then
    ind_cpu3 = widget({ type = "textbox" })
    vicious.register(ind_cpu3, vicious.widgets.cpu, "$3%", 1)
    ind_cpu3.width = 25
    ind_cpu3.align = 'right'
    ind_cpuf3 = widget({ type = "textbox" })
    if have_cpufreq==1 then
        vicious.register(ind_cpuf3, vicious.widgets.cpufreq, "<b><span color='#7F9F7F'>⌚</span></b><span color='#7f7f7f'>$2</span>", 1, "cpu2")
        ind_cpuf3.width = 40
    end
    ind_cpu4 = widget({ type = "textbox" })
    vicious.register(ind_cpu4, vicious.widgets.cpu, "$4%", 1)
    ind_cpu4.width = 25
    ind_cpu4.align = 'right'
    ind_cpuf4 = widget({ type = "textbox" })
    if have_cpufreq==1 then
        vicious.register(ind_cpuf4, vicious.widgets.cpufreq, "<b><span color='#7F9F7F'>⌚</span></b><span color='#7f7f7f'>$2</span>", 1, "cpu3")
        ind_cpuf4.width = 40
    end
end
ind_cputemp = widget({ type = "textbox" })
vicious.register(ind_cputemp, vicious.widgets.thermal, "$1°C", 2, {"coretemp.0", "core", "3"})
ind_fan = widget({ type = "textbox" })
if have_fan==1 then
    vicious.register(ind_fan, vicious.widgets.fan, "<b><span color='#7F9F7F'>☢</span></b>$1 ", 2)
    ind_fan.width = 45
else
    ind_fan.width = 10
end
ind_vtemp = widget({ type = "textbox" })
vicious.register(ind_vtemp, vicious.widgets.nvidiatemp, "<span color='#7f7f7f'>$1°C</span>", 2)
ind_vtemp.width = 40
cpuicon = widget({ type = "imagebox" })
cpuicon.image = image(beautiful.widget_cpu)
ind_top = widget({ type = "textbox" })
vicious.register(ind_top, vicious.widgets.top, "<span color='#7f7f7f'>$2</span><span color='#7F9F7F'>/</span>$3 $1", 1)
ind_top.width = 120
topicon = widget({ type = "imagebox" })
topicon.image = image(beautiful.widget_procs)
memicon = widget({ type = "imagebox" })
memicon.image = image(beautiful.widget_mem)
membar = awful.widget.progressbar()
membar:set_vertical(false):set_ticks(false)
membar:set_height(12):set_width(50)
membar:set_gradient_colors({ "#AECF96", "#88A175", "#FF5656" })
vicious.register(membar, vicious.widgets.mem, "$1", 2)
ind_mem = widget({ type = "textbox" })
vicious.register(ind_mem, vicious.widgets.mem, "$2M<span color='#7F9F7F'>/</span>$6M ", 1)
ind_mem.width=75
dnicon = widget({ type = "imagebox" })
upicon = widget({ type = "imagebox" })
dnicon.image = image(beautiful.widget_net)
upicon.image = image(beautiful.widget_netup)
netwidget = widget({ type = "textbox" })
vicious.register(netwidget, vicious.widgets.net, '<span color="'
  .. beautiful.fg_netdn_widget ..'">${eth0 down_mb}M</span> <span color="'
  .. beautiful.fg_netup_widget ..'">${eth0 up_mb}M</span>', 2)
netwidget.width = 75
neticon = widget({ type = "imagebox" })
neticon.image = image(beautiful.widget_inet)
dnicon = widget({ type = "imagebox" })
upicon = widget({ type = "imagebox" })
dnicon.image = image(beautiful.widget_net)
upicon.image = image(beautiful.widget_netup)
fsicon = widget({ type = "imagebox" })
fsicon.image = image(beautiful.widget_fs)
fs = {
  r = awful.widget.progressbar(),
  h = awful.widget.progressbar()
}
for _, w in pairs(fs) do
  w:set_vertical(false):set_ticks(false)
  w:set_height(12):set_width(50):set_ticks_size(2)
  w:set_border_color(beautiful.border_widget)
  w:set_background_color(beautiful.fg_off_widget)
  w:set_gradient_colors({ beautiful.fg_widget,
     beautiful.fg_center_widget, beautiful.fg_end_widget
  })
end
ind_fsr = widget({ type = "textbox" })
ind_fsh = widget({ type = "textbox" })
-- Enable caching
vicious.cache(vicious.widgets.fs)
vicious.register(ind_fsr, vicious.widgets.fs, "<span color='#7F9F7F'><b>☣</b></span> ${/ used_gb}G<span color='#7F9F7F'>/</span>${/ size_gb}G ", 599)
vicious.register(ind_fsh, vicious.widgets.fs, " <span color='#7F9F7F'><b>☺</b></span> ${/home used_gb}G<span color='#7F9F7F'>/</span>${/home size_gb}G ", 599)
vicious.register(fs.r, vicious.widgets.fs, "${/ used_p}",     599)
vicious.register(fs.h, vicious.widgets.fs, "${/home used_p}", 599)
ind_dio = widget({ type = "textbox" })
vicious.register(ind_dio, vicious.widgets.dio, "<span color='"
  .. beautiful.fg_netdn_widget .. "'>${sda write_mb}M</span> <span color='"
  .. beautiful.fg_netup_widget .. "'>${sda read_mb}M</span>", 2)
ind_dio.width = 75
ind_hddtemp = widget({ type = "textbox" })
vicious.register(ind_hddtemp, vicious.widgets.hddtemp, "${/dev/sda}°C ", 2)
mailicon = widget({ type = "imagebox" })
mailicon.image = image(beautiful.widget_mail)
ind_mail = widget({type = "textbox"})
vicious.register(ind_mail, vicious.widgets.gmail, "<span color='#7F9F7F'>[</span>${count}<span color='#7F9F7F'>]</span> ${subject}", 60)
ind_mail:buttons(awful.util.table.join(
  awful.button({}, 1, function () awful.util.spawn("xdg-open 'https://mail.google.com/mail/u/0'") end)))


--for s = 1, screen.count() do
s=1
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

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "bottom", screen = s, height = 20  })
    -- Add widgets to the wibox - order matters
    mywibox[s].widgets = {
        {
            mylauncher,
            mytaglist[s],
            mylayoutbox[s],
            mypromptbox[s],
            layout = awful.widget.layout.horizontal.leftright
        },
        mytextclock, separator,
        weatherwidget, separator,
        s == 1 and mysystray or nil, separator,
        mytasklist[s],
        layout = awful.widget.layout.horizontal.rightleft
    }

    -- Create indicators
    myindicators[s] = awful.wibox({ position = "top", screen = s, height = 16 })
    if core_count == '4' then
    myindicators[s].widgets = {
        {
            ind_os, ind_uptime,
            separator, cpuicon, ind_cputemp, ind_fan, ind_vtemp, ind_cpu1, ind_cpuf1, ind_cpu2, ind_cpuf2, ind_cpu3, ind_cpuf3, ind_cpu4, ind_cpuf4,
            separator, topicon, ind_top,
            separator, memicon, ind_mem, membar,
            separator, fsicon, ind_hddtemp, dnicon, ind_dio, upicon,
            separator, ind_fsr, fs.r.widget, ind_fsh, fs.h.widget,
            separator, neticon, dnicon, netwidget, upicon,
            separator, mailicon, ind_mail,
            separator, layout = awful.widget.layout.horizontal.leftright
        },
        layout = awful.widget.layout.horizontal.rightleft
    }
    else -- 2 cores
    myindicators[s].widgets = {
        {
            ind_os, ind_uptime,
            separator, cpuicon, ind_cputemp, ind_fan, ind_vtemp, ind_cpu1, ind_cpuf1, ind_cpu2, ind_cpuf2,
            separator, topicon, ind_top,
            separator, memicon, ind_mem, membar,
            separator, fsicon, ind_hddtemp, dnicon, ind_dio, upicon,
            separator, ind_fsr, fs.r.widget, ind_fsh, fs.h.widget,
            separator, neticon, dnicon, netwidget, upicon,
            separator, mailicon, ind_mail,
            separator, layout = awful.widget.layout.horizontal.leftright
        },
        layout = awful.widget.layout.horizontal.rightleft
    }
    end



--end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end)
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
    --awful.key({ modkey,           }, "w", function () mymainmenu:show({keygrabber=true}) end),
    awful.key({ modkey,           }, "w", function () awful.util.spawn("firefox") end),
    awful.key({ modkey,           }, "e", function () awful.util.spawn(filemanager) end),
    awful.key({                   }, "Print", function () awful.util.spawn("scrot -e 'mv $f ~/Изображения/screenshots/ 2>/dev/null'") end),

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

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Shift"   }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    awful.key({ modkey,           }, "b", function () awful.util.spawn("xscreensaver-command -lock") end),

    -- Prompt
    --awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),
    awful.key({ modkey },            "r",     function () awful.util.spawn("gmrun")  end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
--    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end), -- TODO: indicate ontop
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
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
    awful.button({ modkey }, 3, awful.mouse.client.resize),
    awful.button({ }, 8, function () awful.client.swap.byidx(1) end),
    awful.button({ }, 9, function () awful.client.swap.byidx(-1) end))

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
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    { rule = { class = "freemind-main-FreeMindStarter" },
      properties = { tag = tags[1][2] } },
    { rule = { class = "Qtcreator" },
      properties = { tag = tags[1][3] } },
    { rule = { class = "DrRacket" },
      properties = { tag = tags[1][3] } },
    { rule = { class = "Firefox" },
      properties = { tag = tags[1][4] } },
    { rule = { class = "Pidgin", role = "buddy_list"},
      properties = { tag = tags[1][4] } },
    { rule = { class = "Pidgin", role = "conversation"},
      properties = { tag = tags[1][4]}, callback = awful.client.setslave },
    { rule = { instance = "plugin-container" },
      properties = { floating = true } },
    { rule = { class = "Xmessage" },
      properties = { floating = true } },
    { rule = { class = "Display" },
      properties = { floating = true } },
    { rule = { class = "Vlc" },
      properties = { floating = true } },
    { rule = { class = "Smplayer" },
      properties = { floating = true } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })

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
        -- awful.client.setslave(c)

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

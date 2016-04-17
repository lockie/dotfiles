
city = "UUEE"  -- Шереметьево. См. http://www.earthcam.com/myec/yourwebcam/metar_instructions.php
home = os.getenv("HOME")

-- Standard awesome library
awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
beautiful = require("beautiful")
-- Notification library
naughty = require("naughty")
wibox = require("wibox")

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
require("vicious.widgets.weather")

require("calendar2")

-- {{{ Autostart

function run_once(cmd)
  findme = cmd
  firstspace = cmd:find(" ")
  if firstspace then
    findme = cmd:sub(0, firstspace-1)
  end
  awful.util.spawn_with_shell("pgrep -u $USER -x " .. findme .. " > /dev/null || (" .. cmd .. ")")
end

awful.util.spawn_with_shell("nitrogen --restore")
awful.util.spawn_with_shell("xsetroot -cursor_name left_ptr")
awful.util.spawn_with_shell("xset r rate 190 25")
awful.util.spawn_with_shell("xset -dpms & xset s off")
run_once("xscreensaver -nosplash")
run_once("volumeicon")
run_once("zim --plugin trayicon")
run_once("/opt/bin/dropbox")

awesome.connect_signal("exit", function() awful.util.spawn("killall dropbox ; killall zim") end)

-- }}}


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
    awesome.connect_signal("debug::error", function (err)
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
   { "shutdown", home .. "/bin/shutdown_dialog.py", "/usr/share/icons/nuoveXT2/128x128/actions/system-shutdown.png" },
   { "restart", awesome.restart },
   { "config", editor_cmd .. " " .. awesome.conffile, "/usr/share/icons/nuoveXT2/128x128/apps/text-editor.png" },
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "firefox", "firefox", "/usr/share/icons/nuoveXT2/128x128/apps/firefox-icon.png" },
                                    { "telegram", home .. "/bin/Telegram/Telegram", home .. "/bin/Telegram/telegram.png"},
                                    { "skype", "/opt/bin/skype", "/usr/share/icons/hicolor/128x128/apps/skype.png" },
                                    { "deadbeef", "/usr/bin/deadbeef", "/usr/share/icons/hicolor/192x192/apps/deadbeef.png" },
                                    { "terminal", terminal, "/usr/share/icons/nuoveXT2/128x128/apps/terminal.png" }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })
-- }}}

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock("%H:%M:%S", 1)
calendar2.addCalendarToWidget(mytextclock, "<span color='green'>%s</span>")

-- Create a systray
mysystray = wibox.widget.systray()

-- reusable separator
separator = wibox.widget.imagebox()
separator:set_image(beautiful.widget_sep)

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

weatherwidget = wibox.widget.textbox()
vicious.register(weatherwidget, vicious.widgets.weather, "${tempc}°C", 593, city)

ind_os = wibox.widget.textbox()
vicious.register(ind_os, vicious.widgets.os, "$4<span color='#7F9F7F'><b>@</b></span>$2")
ind_os = wibox.layout.constraint(ind_os, "exact", 190, nil)
ind_uptime = wibox.widget.textbox()
vicious.register(ind_uptime, vicious.widgets.uptime,
  '<span color="#7F9F7F"><b>↑</b></span>$1d $2h $3m')
ind_uptime = wibox.layout.constraint(ind_uptime, "exact", 90, nil)
ind_cpu1 = wibox.widget.textbox()
vicious.register(ind_cpu1, vicious.widgets.cpu, "$1%", 1)
vicious.cache(vicious.widgets.cpu)
ind_cpu1:set_align('right')
ind_cpu1 = wibox.layout.constraint(ind_cpu1, "exact", 35, nil)
ind_cpuf1 = wibox.widget.textbox()
if have_cpufreq==1 then
    vicious.register(ind_cpuf1, vicious.widgets.cpufreq, "<b><span color='#7F9F7F'>⌚</span></b><span color='#7f7f7f'>$2</span>", 1, "cpu0")
    ind_cpuf1 = wibox.layout.constraint(ind_cpuf1, "exact", 40, nil)
else
    ind_cpuf1 = wibox.layout.constraint(ind_cpuf1, "exact", 10, nil)
end
ind_cpu2 = wibox.widget.textbox()
vicious.register(ind_cpu2, vicious.widgets.cpu, "$2%", 1)
ind_cpu2:set_align('right')
ind_cpu2 = wibox.layout.constraint(ind_cpu2, "exact", 35, nil)
ind_cpuf2 = wibox.widget.textbox()
if have_cpufreq==1 then
    vicious.register(ind_cpuf2, vicious.widgets.cpufreq, "<b><span color='#7F9F7F'>⌚</span></b><span color='#7f7f7f'>$2</span>", 1, "cpu1")
    ind_cpuf2 = wibox.layout.constraint(ind_cpuf2, "exact", 40, nil)
else
    ind_cpuf1 = wibox.layout.constraint(ind_cpuf1, "exact", 10, nil)
end
if core_count == '4' then
    ind_cpu3 = wibox.widget.textbox()
    vicious.register(ind_cpu3, vicious.widgets.cpu, "$3%", 1)
    ind_cpu3:set_align('right')
    ind_cpu3 = wibox.layout.constraint(ind_cpu3, "exact", 35, nil)
    ind_cpuf3 = wibox.widget.textbox()
    if have_cpufreq==1 then
        vicious.register(ind_cpuf3, vicious.widgets.cpufreq, "<b><span color='#7F9F7F'>⌚</span></b><span color='#7f7f7f'>$2</span>", 1, "cpu2")
        ind_cpuf3 = wibox.layout.constraint(ind_cpuf3, "exact", 40, nil)
    end
    ind_cpu4 = wibox.widget.textbox()
    vicious.register(ind_cpu4, vicious.widgets.cpu, "$4%", 1)
    ind_cpu4:set_align('right')
    ind_cpu4 = wibox.layout.constraint(ind_cpu3, "exact", 35, nil)
    ind_cpuf4 = wibox.widget.textbox()
    if have_cpufreq==1 then
        vicious.register(ind_cpuf4, vicious.widgets.cpufreq, "<b><span color='#7F9F7F'>⌚</span></b><span color='#7f7f7f'>$2</span>", 1, "cpu3")
        ind_cpuf4 = wibox.layout.constraint(ind_cpuf4, "exact", 40, nil)
    end
end
ind_cputemp = wibox.widget.textbox()
vicious.register(ind_cputemp, vicious.widgets.thermal, "$1°C", 2, {"thermal_zone0", "sys", "3"})
ind_fan = wibox.widget.textbox()
if have_fan==1 then
    vicious.register(ind_fan, vicious.widgets.fan, "<b><span color='#7F9F7F'>☢</span></b>$1 ", 2)
    ind_fan = wibox.layout.constraint(ind_fan, "exact", 55, nil)
else
    ind_fan = wibox.layout.constraint(ind_fan, "exact", 10, nil)
end
ind_vtemp = wibox.widget.textbox()
vicious.register(ind_vtemp, vicious.widgets.nvidiatemp, "<span color='#7f7f7f'>$1°C</span>", 3)
ind_vtemp = wibox.layout.constraint(ind_vtemp, "exact", 35, nil)
cpuicon = wibox.widget.imagebox()
cpuicon:set_image(beautiful.widget_cpu)
ind_top = wibox.widget.textbox()
vicious.register(ind_top, vicious.widgets.top, "<span color='#7f7f7f'>$2</span><span color='#7F9F7F'>/</span>$3 $1", 1)
ind_top = wibox.layout.constraint(ind_top, "exact", 140, nil)
topicon = wibox.widget.imagebox()
topicon:set_image(beautiful.widget_procs)
memicon = wibox.widget.imagebox()
memicon:set_image(beautiful.widget_mem)
membar = awful.widget.progressbar()
membar:set_vertical(false):set_ticks(false)
membar:set_height(12):set_width(50)
membar:set_color({ type = "linear", from = {0, 0}, to = {0, 50}, stops = { {0, "#AECF96"}, {0.5, "#88A175"}, {1, "#FF5656"} } })
vicious.register(membar, vicious.widgets.mem, "$1", 5)
ind_mem = wibox.widget.textbox()
vicious.register(ind_mem, vicious.widgets.mem, "$2M<span color='#7F9F7F'>/</span>$6M ", 1)
ind_mem = wibox.layout.constraint(ind_mem, "exact", 75, nil)
dnicon = wibox.widget.imagebox()
upicon = wibox.widget.imagebox()
dnicon:set_image(beautiful.widget_net)
upicon:set_image(beautiful.widget_netup)
netwidget = wibox.widget.textbox()
vicious.register(netwidget, vicious.widgets.net, '<span color="'
  .. beautiful.fg_netdn_widget ..'">${eth0 down_mb}M</span> <span color="'
  .. beautiful.fg_netup_widget ..'">${eth0 up_mb}M</span>', 2)
netwidget = wibox.layout.constraint(netwidget, "exact", 85, nil)
neticon = wibox.widget.imagebox()
neticon:set_image(beautiful.widget_inet)
dnicon = wibox.widget.imagebox()
upicon = wibox.widget.imagebox()
dnicon:set_image(beautiful.widget_net)
upicon:set_image(beautiful.widget_netup)
fsicon = wibox.widget.imagebox()
fsicon:set_image(beautiful.widget_fs)
fs = {
  r = awful.widget.progressbar(),
  h = awful.widget.progressbar()
}
for _, w in pairs(fs) do
  w:set_vertical(false):set_ticks(false)
  w:set_height(12):set_width(50):set_ticks_size(2)
  w:set_border_color(beautiful.border_widget)
  w:set_background_color(beautiful.fg_off_widget)
  w:set_color({ type = "linear", from = {0, 0}, to = {0, 50},
     stops = { {0, beautiful.fg_widget}, {0.5, beautiful.fg_center_widget}, {1, beautiful.fg_end_widget} } })
end
ind_fsr = wibox.widget.textbox()
ind_fsh = wibox.widget.textbox()
-- Enable caching
vicious.cache(vicious.widgets.fs)
vicious.register(ind_fsr, vicious.widgets.fs, "<span color='#7F9F7F'><b>☣</b></span> ${/ used_gb}G<span color='#7F9F7F'>/</span>${/ size_gb}G ", 599)
vicious.register(ind_fsh, vicious.widgets.fs, " <span color='#7F9F7F'><b>☺</b></span> ${/home used_gb}G<span color='#7F9F7F'>/</span>${/home size_gb}G ", 599)
vicious.register(fs.r, vicious.widgets.fs, "${/ used_p}",     599)
vicious.register(fs.h, vicious.widgets.fs, "${/home used_p}", 599)
ind_dio = wibox.widget.textbox()
vicious.register(ind_dio, vicious.widgets.dio, "<span color='"
  .. beautiful.fg_netdn_widget .. "'>${sda write_mb}M</span> <span color='"
  .. beautiful.fg_netup_widget .. "'>${sda read_mb}M</span>", 2)
ind_dio = wibox.layout.constraint(ind_dio, "exact", 85, nil)
ind_hddtemp = wibox.widget.textbox()
vicious.register(ind_hddtemp, vicious.widgets.hddtemp, "${/dev/sda}°C ", 7)
mailicon = wibox.widget.imagebox()
mailicon:set_image(beautiful.widget_mail)
ind_mail = wibox.widget.textbox()
vicious.register(ind_mail, vicious.widgets.gmail, "<span color='#7F9F7F'>[</span>${count}<span color='#7F9F7F'>]</span> ${subject}", 59)
ind_mail:buttons(awful.util.table.join(
  awful.button({}, 1, function () awful.util.spawn("xdg-open 'https://mail.google.com/mail/u/0'") end)))


--for s = 1, screen.count() do
s=1
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "bottom", screen = s, height = 20  })
    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mylauncher)
    left_layout:add(mytaglist[s])
    left_layout:add(mylayoutbox[s])
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then right_layout:add(wibox.widget.systray()) end
    right_layout:add(separator)
    right_layout:add(weatherwidget)
    right_layout:add(separator)
    right_layout:add(mytextclock)


    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)

    -- Create indicators
    local ind_layout = wibox.layout.fixed.horizontal()
    if core_count == '4' then
        ind_layout:add(ind_os); ind_layout:add(ind_uptime)
        ind_layout:add(separator); ind_layout:add(cpuicon); ind_layout:add(ind_cputemp); ind_layout:add(ind_fan); ind_layout:add(ind_vtemp)
            ind_layout:add(ind_cpu1); ind_layout:add(ind_cpuf1); ind_layout:add(ind_cpu2); ind_layout:add(ind_cpuf2); ind_layout:add(ind_cpu3); ind_layout:add(ind_cpuf3); ind_layout:add(ind_cpu4); ind_layout:add(ind_cpuf4)
        ind_layout:add(separator); ind_layout:add(topicon); ind_layout:add(ind_top)
        ind_layout:add(separator); ind_layout:add(memicon); ind_layout:add(ind_mem); ind_layout:add(membar)
        ind_layout:add(separator); ind_layout:add(fsicon); ind_layout:add(ind_hddtemp); ind_layout:add(dnicon); ind_layout:add(ind_dio); ind_layout:add(upicon)
        ind_layout:add(separator); ind_layout:add(ind_fsr); ind_layout:add(fs.r);  ind_layout:add(ind_fsh); ind_layout:add(fs.h)
        ind_layout:add(separator); ind_layout:add(neticon); ind_layout:add(dnicon); ind_layout:add(netwidget); ind_layout:add(upicon)
        ind_layout:add(separator); ind_layout:add(mailicon); ind_layout:add(ind_mail)
        ind_layout:add(separator)
    else -- 2 cores
        ind_layout:add(ind_os); ind_layout:add(ind_uptime)
        ind_layout:add(separator); ind_layout:add(cpuicon); ind_layout:add(ind_cputemp); ind_layout:add(ind_fan); ind_layout:add(ind_vtemp)
            ind_layout:add(ind_cpu1); ind_layout:add(ind_cpuf1); ind_layout:add(ind_cpu2); ind_layout:add(ind_cpuf2)
        ind_layout:add(separator); ind_layout:add(topicon); ind_layout:add(ind_top)
        ind_layout:add(separator); ind_layout:add(memicon); ind_layout:add(ind_mem); ind_layout:add(membar)
        ind_layout:add(separator); ind_layout:add(fsicon); ind_layout:add(ind_hddtemp); ind_layout:add(dnicon); ind_layout:add(ind_dio); ind_layout:add(upicon)
        ind_layout:add(separator); ind_layout:add(ind_fsr); ind_layout:add(fs.r.widget); ind_layout:add(ind_fsh); ind_layout:add(fs.h.widget)
        ind_layout:add(separator); ind_layout:add(neticon); ind_layout:add(dnicon); ind_layout:add(netwidget); ind_layout:add(upicon)
        ind_layout:add(separator); ind_layout:add(mailicon); ind_layout:add(ind_mail)
        ind_layout:add(separator)
    end
    local l = wibox.layout.align.horizontal()
    l:set_left(ind_layout)
    myindicators[s] = awful.wibox({ position = "top", screen = s, height = 16 })
    myindicators[s]:set_widget(l)

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
    awful.key({ modkey },            "r",     function () awful.util.spawn("rofi -show run -fuzzy -levenshtein-sort -lines 5 -width -37 -terminal " .. terminal)  end),

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
    { rule = { name = "gst-launch-0.10" },
      properties = { floating = true } },
    { rule = { name = "gst-launch-1.0" },
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
    { rule = { instance = "Download" },
      properties = { floating = true } },
    { rule = { class = "Pidgin", role = "buddy_list"},
      properties = { tag = tags[1][4] } },
    { rule = { class = "Pidgin", role = "conversation"},
      properties = { tag = tags[1][4]}, callback = awful.client.setslave },
    { rule = { instance = "plugin-container" },
      properties = { floating = true } },
    { rule = { instance = "exe" },
      properties = { floating = true } },
    { rule = { class = "Xmessage" },
      properties = { floating = true } },
    { rule = { class = "Display" },
      properties = { floating = true } },
    { rule = { class = "Vlc" },
      properties = { floating = true } },
    { rule = { class = "Smplayer" },
      properties = { floating = true } },
    { rule = { class = "psi" },
      properties = {tag = tags[1][4]}
    }
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })

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

    -- http://awesome.naquadah.org/wiki/IM_tips#Psi_and_qutIM
    if c.class == "psi" and not c.name:find("Psi") then
        awful.client.setslave(c)
        awful.tag.setmwfact (0.2, tags[2][4])
    end

   -- Floating clients don't overlap, cover
   -- the titlebar or get placed offscreen
   awful.placement.no_overlap(c)
   awful.placement.no_offscreen(c)

end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

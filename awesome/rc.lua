-- {{{ Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")

-- Load Debian menu entries
require("debian.menu")
-- }}}

-- {{{ Error handling
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
-- loclaization
os.setlocale(os.getenv("LANG"))

-- home path
homedir = awful.util.getdir("config")

-- Themes
themeName = "rbown"
-- themeName = "brown"
-- themeName = "wmii"
themesPath = homedir .. "/themes/"
beautiful.init(themesPath .. themeName .. "/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "x-terminal-emulator"
-- terminal = "urxvtc"
editor = os.getenv("EDITOR") or "editor"
editor_cmd = terminal .. " -e " .. editor
gui_editor = "gvim"
graphics = "gimp"

-- Default modkey.
modkey = "Mod4"
altkey = "Mod1"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.tile,
    awful.layout.suit.tile.bottom,
}
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {
    names = {
        "[Firefox]",
        "[Vim]",
        "[Term]",
        "[Files]",
        "[VBox]",
    },
    layout = { 
        layouts[1], 
        layouts[1],
        layouts[1],
        layouts[1],
        layouts[1],
    }
}
for s = 1, screen.count() do
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

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
{ "Debian", debian.menu.Debian_menu.Debian },
{ "open terminal", terminal } } })

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
menu = mymainmenu })
-- }}}

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock({ align = "right"}, "%Y年%m月%d日  %A   %H:%M", 60) 

-- Create a systray
mysystray = widget({ type = "systray" })

-- Create a wibox for each screen and add it
mywibox = {}
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

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })
    -- Add widgets to the wibox - order matters
    mywibox[s].widgets = {
        {
            mylauncher,
            mytaglist[s],
            mypromptbox[s],
            layout = awful.widget.layout.horizontal.leftright
        },
        mylayoutbox[s],
        mytextclock,
        s == 1 and mysystray or nil,
        mytasklist[s],
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
-- 切换屏幕
awful.key({ modkey, "shift"   }, "w", function () awful.screen.focus_relative( 1) end),
awful.key({ modkey, "shift"   }, "e", function () awful.screen.focus_relative(-1) end),

-- 切换工作区
awful.key({ modkey,           }, "w",      awful.tag.viewprev       ),
awful.key({ modkey,           }, "e",      awful.tag.viewnext       ),
awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

-- 切换窗口
awful.key({ modkey, altkey    }, "k", 
    function () awful.client.focus.byidx(1)
        if client.focus then client.focus:raise() end
    end),
awful.key({ modkey, altkey    }, "j", 
    function () awful.client.focus.byidx(-1)
        if client.focus then client.focus:raise() end
    end),
awful.key({ modkey,           }, "j", 
    function () awful.client.focus.bydirection("down")
        if client.focus then client.focus:raise() end
    end),
awful.key({ modkey,           }, "k",
    function () awful.client.focus.bydirection("up")
        if client.focus then client.focus:raise() end
    end),
awful.key({ modkey,           }, "h",
    function () awful.client.focus.bydirection("left")
        if client.focus then client.focus:raise() end
    end),
awful.key({ modkey,           }, "l",
    function () awful.client.focus.bydirection("right")
        if client.focus then client.focus:raise() end
    end),
awful.key({ modkey,           }, ";",
    function ()
        awful.client.focus.history.previous()
        if client.focus then
            client.focus:raise()
        end
    end),

-- 移动标签
awful.key({ modkey,           }, "u",       function () awful.client.swap.byidx(  1)    end),
awful.key({ modkey,           }, "i",       function () awful.client.swap.byidx( -1)    end),

-- 调整窗口大小
awful.key({ modkey, altkey    }, "l",       function () awful.tag.incmwfact( 0.05)    end),
awful.key({ modkey, altkey    }, "h",       function () awful.tag.incmwfact(-0.05)    end),
awful.key({ modkey,           }, "x",       function () awful.tag.incmwfact( 0.05)    end),
awful.key({ modkey,           }, "z",       function () awful.tag.incmwfact(-0.05)    end),
awful.key({ modkey, "Shift"   }, "x",       function () awful.tag.incnmaster( 1)      end),
awful.key({ modkey, "Shift"   }, "z",       function () awful.tag.incnmaster(-1)      end),
awful.key({ modkey, "Control" }, "x",       function () awful.tag.incncol( 1)         end),
awful.key({ modkey, "Control" }, "z",       function () awful.tag.incncol(-1)         end),

-- 切换布局
awful.key({ modkey,           }, "space",   function () awful.layout.inc(layouts,  1) end),
awful.key({ modkey, "Shift"   }, "space",   function () awful.layout.inc(layouts, -1) end),

-- 启动程序
awful.key({ modkey,           }, "Return",  function () awful.util.spawn(terminal) end),
awful.key({ modkey,           }, "r",       function () mypromptbox[mouse.screen]:run() end),
awful.key({ modkey, "Shift"   }, "r",
function ()
    awful.prompt.run({ prompt = "Run Lua code: " },
    mypromptbox[mouse.screen].widget,
    awful.util.eval, nil,
    awful.util.getdir("cache") .. "/history_eval")
end),

-- 恢复窗口
awful.key({ modkey, "Control" }, "n",       awful.client.restore),

-- 获取某个窗口的名字和类信息
awful.key({ modkey, }, "F10",
function ()
    awful.util.spawn_with_shell("zenity --info --no-wrap --text=\"`xprop | grep --color=none \"WM_CLASS\|^WM_NAME\"`\"")
end),

awful.key({ modkey, "Control" }, "r",       awesome.restart),
awful.key({ modkey, "Shift"   }, "q",       awesome.quit)

-- awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
-- awful.key({ modkey,           }, "w", function () mymainmenu:show({keygrabber=true}) end),

)

clientkeys = awful.util.table.join(
-- 窗口控制

-- 全屏
awful.key({ modkey,           }, "F11",    function (c) c.fullscreen = not c.fullscreen  end),
-- 关闭窗口
awful.key({ modkey,           }, "c",      function (c) c:kill()                         end),
-- 设为浮动
awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
-- 设为主窗口
awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
-- 移到另一块屏幕中去
awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
-- 置顶
awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
-- 最小化
awful.key({ modkey,           }, "n",
function (c)
    -- The client currently has the input focus, so it cannot be
    -- minimized, since minimized clients can't have the focus.
    c.minimized = true
end),
-- 最大化
awful.key({ modkey,           }, "m",
function (c)
    c.maximized_horizontal = not c.maximized_horizontal
    c.maximized_vertical   = not c.maximized_vertical
end)
-- 重画窗口
-- awful.key({ modkey, "Control" }, "r",      function (c) c:redraw()                       end),
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
    awful.key({ modkey, "Shift" }, "#" .. i + 9,
    function ()
        local screen = mouse.screen
        if tags[screen][i] then
            awful.tag.viewtoggle(tags[screen][i])
        end
    end),
    awful.key({ modkey, "Control" }, "#" .. i + 9,
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
-- 自定义几个工作区切换热键
SwitchTagHotKeys = {"a", "s", "d", "f", "g"}
for i = 1, #SwitchTagHotKeys do
    globalkeys = awful.util.table.join(globalkeys,
    awful.key({modkey            }, SwitchTagHotKeys[i], 
    function ()
        local screen = mouse.screen
        if tags[screen][i] then
            awful.tag.viewonly(tags[screen][i])
        end
    end),
    awful.key({modkey, "Shift"   }, SwitchTagHotKeys[i], 
    function ()
        local screen = mouse.screen
        if tags[screen][i] then
            awful.tag.viewtoggle(tags[screen][i])
        end
    end),
    awful.key({modkey, "Control" }, SwitchTagHotKeys[i],
    function ()
        if client.focus and tags[client.focus.screen][i] then
            awful.client.movetotag(tags[client.focus.screen][i])
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

screenIndex = screen.count() 
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
        properties = { 
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = true,
            keys = clientkeys,
            size_hints_honor = false,
            buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
        properties = { floating = true } },
    { rule = { class = "Smplayer" },
        properties = { floating = true } },
    { rule = { class = "pinentry" },
        properties = { floating = true } },
    { rule = { class = "gimp" },
        properties = { floating = true } },
    { rule = { class = "Firefox", name = "Download" },
        properties = { floating = true } },
    { rule = { class = "Firefox" },
        properties = { tag = tags[screenIndex][1] } },
    { rule = { class = "Gvim" },
        properties = { tag = tags[screenIndex][2] } },
    { rule = { class = "VirtualBox" },
        properties = { floating = true, tag = tags[screenIndex][5] } }
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:add_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- {{{ 自启动
autorunApps = 
{ 
    "firefox",
    "gvim",
    "gnome-screensaver",
    "gnome-settings-daemon",
    "goldendict",
    -- "x-terminal-emulator",
    "vmware-user",
    "/usr/bin/env python '/home/goodhzz/Downloads/goagent/local/goagent-gtk.py'",
    "ubuntuone-launch",
    "gnome-sound-applet"
}

function is_running(app_name)
    ret = awful.util.pread("pgrep -u $USER -x " .. app_name)
    if ret == "" then
        return false
    else
        return true
    end
end

if not is_running(autorunApps[1]) then
    for app = 1, #autorunApps do
        awful.util.spawn_with_shell(autorunApps[app])
    end
end

-- run_once("nm-applet")
-- run_once("gnome-power-manager")

-- run_once("urxvtd")
-- run_once("unclutter")
-- }}}
<<<<<<< HEAD



=======
>>>>>>> a584149a8bd9eaa3bad89ea77470e09b7f8015c4

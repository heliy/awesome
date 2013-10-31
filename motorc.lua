-- [  ]
--------------------------------------------

-- [ Refer ]--{{{
--------------------------------------------
-- From : Gigamo        awesome 配置 [git]
-- From : default       /etc/xdg/awesome/rc.lua
-- From : ubuntu        http://wiki.ubuntu.org.cn/Awesome#.E6.97.B6.E9.97.B4
-- From : ArchWiki      https://wiki.archlinux.org/index.php/Awesome3
-- From : awesome-vain  https://github.com/vain/awesome-vain

--}}}

-- {{{ Tables StatusBar 组件定义
-- 状态栏 组件
local tags      = { }
-- 整个 状态栏
local statusbar = { }
-- Run 运行
local promptbox = { }
-- 虚拟桌面标签
local taglist   = { }
-- 窗口状态栏
local mytasklist  = { }
-- 窗口布局模式
local layoutbox = { }
-- }}}

-- {{{ Imports 导入 引用文件

require('awful')
require('awful.autofocus')
require('awful.rules')
-- Theme handling library
require('beautiful')
-- Notification library 信息提示 类库
require('naughty')
-- Debian 菜单
-- require("debian.menu")
-- Load Theme 主题
beautiful.init(awful.util.getdir('config')..'/zenburn.lua')

-- wallpaper 桌面壁纸 在 主题中也有设置，转移到 .xinirc 文件里面
-- theme.wallpaper_cmd = { "awsetbg -f /home/ink/pic/wall/shanshui.jpg" }
theme.wallpaper_cmd = { "feh --bg-scale ~/pic/wall/glass.jpg" }

--xcompmgr -l -5 -t -5 -r 5 -o 0.60 -c &
--feh --bg-scale ~/pic/wall/glass.jpg

-- }}}

-- {{{ Variables 全局变量

local settings  = { }

settings.modkey  = 'Mod4'
settings.term    = 'xterm'
settings.browser = 'firefox'

-- For Debian
--terminal = "x-terminal-emulator"
terminal = "xterm"
editor = os.getenv("EDITOR") or "editor"
editor_cmd = terminal .. " -e " .. editor

-- 在 theme 主题文件中定义
-- awesome.font = "snap 9"

-- widget 函数里面定义的分隔符
local separator_l = ' '
local separator_r = '| '


-- }}}

-- {{{ Tags 虚拟桌面标签

-- 布局样式 --{{{

-- [ 默认支持的窗口布局 ]--{{{
--------------------------------------------
-- From Debian awesome /etc
-- awful.layout.*

--layouts =
--{
--    awful.layout.suit.floating,
--    awful.layout.suit.tile,
--    awful.layout.suit.tile.left,
--    awful.layout.suit.tile.bottom,
--    awful.layout.suit.tile.top,
--    awful.layout.suit.fair,
--    awful.layout.suit.fair.horizontal,
--    awful.layout.suit.spiral,
--    awful.layout.suit.spiral.dwindle,
--    awful.layout.suit.max,
--    awful.layout.suit.max.fullscreen,
--    awful.layout.suit.magnifier
--}

--}}}

-- 自定义支持的窗口 布局样式
settings.layouts =
{
    awful.layout.suit.tile,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.max,
    awful.layout.suit.magnifier,
    awful.layout.suit.floating
}

--}}}

tags.settings = {
    { name = 'term', layout = settings.layouts[1]  },
    -- 浏览器改为 浮动
    { name = 'web',  layout = settings.layouts[5]  },
    { name = 'dev',  layout = settings.layouts[1]  },
    { name = 'im',   layout = settings.layouts[5], mwfact = 0.13 },
--    { name = 'im',   layout = settings.layouts[1], mwfact = 0.13 },
    { name = 'misc ', layout = settings.layouts[5]  },
}

for s = 1, screen.count() do
    tags[s] = {}
    for i, v in ipairs(tags.settings) do
        tags[s][i] = tag({ name = v.name })
        tags[s][i].screen = s
        awful.tag.setproperty(tags[s][i], 'layout', v.layout)
        awful.tag.setproperty(tags[s][i], 'mwfact', v.mwfact)
        awful.tag.setproperty(tags[s][i], 'hide',   v.hide)
    end
    tags[s][1].selected = true
end

-- }}}

-- {{{ Menu 菜单

-- 状态栏 [ 开始 ] 菜单按键
--mylauncher = awful.widget.l状态栏 auncher({ image = image(beautiful.awesome_icon),
--                                     menu = mymainmenu })

-- 菜单中 显示图标
--mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
--                                    { "Debian", debian.menu.Debian_menu.Debian },
--mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu },
--                                    --{ "Debian", debian.menu.Debian_menu.Debian },
--                                    { "open terminal", terminal }
--                                  }
--                        })

myawesomemenu = {
   { "lock", "xscreensaver-command -activate" },
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua" },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

myoffice = {
   { "base", "lobase" },
   { "writer", "lowriter" },
   { "calc", "localc" },
   { "draw", "lodraw" },
   { "impress", "loimpress" },
   { "math", "lomath" },
   { "web", "loweb" }
}
mycommons = {
   { "writer", "lowriter" },
   { "leafpad", "leafpad" },
   { "mtpaint", "mtpaint" },
   { "pidgin", "pidgin" },
   { "virtualbox", "VirtualBox" }
}

mymainmenu = awful.menu({ items = {
                                        { "terminal", terminal },
                                        { "firefox", "firefox" },
                                        { "pcmanfm", "pcmanfm" },
                                        { "writer", "lowriter" },
                                        { "leafpad", "leafpad" },
                                        { "mtpaint", "mtpaint" },
                                        { "pidgin", "pidgin" },
                                        { "office", myoffice },
                                        --{ "common", mycommons, beautiful.awesome_icon },
                                        --{ "awesome", myawesomemenu, beautiful.awesome_icon }
                                        { "awesome", myawesomemenu }
                                       }
                             })


-- }}}

--  StatusBar 状态栏--{{{

-- Widgets--{{{
--------------------------------------------
-- 系统托盘
systray       = widget({ type = 'systray' })

-- 电池电量--{{{

batwidget     = widget({ type = 'textbox', name = 'batwidget' })

function battery(id)
    -- Ugly long HAL string
    hal = io.popen('hal-get-property --udi /org/freedesktop/Hal/devices/computer_power_supply_battery_'..id..' --key battery.charge_level.percentage')
    if hal then
        charge = hal:read('*all')
        hal:close()
    end

    return charge:gsub("\n", '')..'%'.. ' |'
end

battimer = timer { timeout = 30 }
battimer:add_signal('timeout', function() batwidget.text = battery('BAT1') end)
battimer:start()

--}}}

-- 内存--{{{

memwidget     = widget({ type = 'textbox', name = 'memwidget' })

function memory()
    local memfile = io.open('/proc/meminfo')
    if memfile then
        for line in memfile:lines() do
            if line:match("^MemTotal.*") then
                mem_total = math.floor(tonumber(line:match("(%d+)")) / 1024)
            elseif line:match("^MemFree.*") then
                mem_free = math.floor(tonumber(line:match("(%d+)")) / 1024)
            elseif line:match("^Buffers.*") then
                mem_buffers = math.floor(tonumber(line:match("(%d+)")) / 1024)
            elseif line:match("^Cached.*") then
                mem_cached = math.floor(tonumber(line:match("(%d+)")) / 1024)
            end
        end
        memfile:close()
    end
    local mem_in_use = mem_total - (mem_free + mem_buffers + mem_cached)
    local mem_usage_percentage = math.floor(mem_in_use / mem_total * 100)

    return mem_in_use..' M'..' | '
end

memtimer = timer { timeout = 15 }
memtimer:add_signal('timeout', function() memwidget.text = memory() end)
memtimer:start()

--}}}

-- 温度--{{{
-- 依赖于 lm_sensors 查看温度软件

thermalwidget = widget({ type = 'textbox', name = 'thermalwidget' })

function thermal()
    local temperature, howmany = 0, 0
    local sensors = io.popen('sensors')
    if sensors then
        for line in sensors:lines() do
            if line:match(':%s+%+([.%d]+)') then
                howmany = howmany + 1
                temperature = temperature + tonumber(line:match(':%s+%+([.%d]+)'))
            end
        end
        sensors:close()
    end
    temperature = temperature / howmany

    --return temperature..'°C'..' | '
    return temperature..'C'..' | '
end

thermaltimer = timer { timeout = 15 }
thermaltimer:add_signal('timeout', function() thermalwidget.text = thermal() end)
thermaltimer:start()

--}}}

-- {{{ Load Averag

loadavgwidget = widget({ type = 'textbox', name = 'loadavgwidget' })

function systemload()
    local f = io.open("/proc/loadavg")
    local ret = f:read("*all")
    f:close()

    local a, b, c = string.match(ret, "([^%s]+) ([^%s]+) ([^%s]+)")
    local sysload = string.format("%s %s %s", a, b, c)
    return sysload..' | '
end

-- 刷新时间
loadtimer = timer({ timeout = 10 })
loadtimer:add_signal('timeout', function() loadavgwidget.text = systemload() end)
loadtimer:start()

-- 鼠标点击打开终端，启动 htop
loadavgwidget:buttons(awful.util.table.join(
-- 默认 0 是 所有鼠标点击，都会弹出对话框 [?]
awful.button({}, 3,
    function()
        awful.util.spawn(terminal .. ' -e htop')
    end)
))

-- }}}

-- {{{ 错误提示 时间格式 [?]

io.stderr:write("\n\rAwesome loaded at "..os.date('%B %d, %H:%M').."\r\n\n")

-- }}}

-- [ 时间格式 ]--{{{
--------------------------------------------

clockwidget   = awful.widget.textclock({ align = 'right' })
-- 时间显示，在 functions.lua 中类似的 clock 定义
-- From : Ubuntu wiki
-- http://wiki.ubuntu.org.cn/Awesome#.E6.97.B6.E9.97.B4
awful.hooks.timer.register(1, function ()
    --clockwidget.text = " " ..os.date("20%y年%m月%d %H:%M ").. " " 
    clockwidget.text = " " ..os.date("%m-%d / %u %H:%M ").. " " 
end)

--}}}

--------------------------------------------
---- [ From : awesome-vain ]--{{{
----------------------------------------------
--
--function systemload()
--    -- 绘制
--    local mysysload = widget({ type = "textbox" })
--    local mysysloadupdate = function()
--        local f = io.open("/proc/loadavg")
--        local ret = f:read("*all")
--        f:close()
--
--        local a, b, c = string.match(ret, "([^%s]+) ([^%s]+) ([^%s]+)")
--        mysysload.text = string.format("%s %s %s", a, b, c)
--        mysysload.text = ' <span color="' .. beautiful.fg_urgent .. '">'
--                         .. mysysload.text .. '</span> '
--    end
--    -- 刷新时间
--    mysysloadupdate()
--    local mysysloadtimer = timer({ timeout = 10 })
--    mysysloadtimer:add_signal("timeout", mysysloadupdate)
--    mysysloadtimer:start()
--    -- 中键打开终端，启动 htop
--    mysysload:buttons(awful.util.table.join(
--        awful.button({}, 0,
--            function()
--                awful.util.spawn(terminal .. ' -e htop')
--            end)
--    ))
--    return mysysload
--end
--
----}}}

-- {{{ CPU 频率 / 温度

--cpuwidget     = widget({ type = 'textbox', name = 'cpuwidget' })

--function cpu()
--    local temperature, howmany = 0, 0
--    local sensors = io.popen('sensors')
--    if sensors then
--        for line in sensors:lines() do
--            if line:match(':%s+%+([.%d]+)') then
--                howmany = howmany + 1
--                temperature = temperature + tonumber(line:match(':%s+%+([.%d]+)'))
--            end
--        end
--        sensors:close()
--    end
--    temperature = temperature / howmany
--    local freq = {}
--    for i = 0, 1 do
--        freq[i] = fread('/sys/devices/system/cpu/cpu'..i..'/cpufreq/scaling_cur_freq'):match('(.*)000')
--    end
--
--    --widget.text = separator_l..freq[0]..'/'..freq[1]..'MHz @ '..temperature..'C'..separator_r
--    return freq[0]..'/'..freq[1]..'MHz @ '..temperature..'C'..' | '
--end

--cputimer = timer { timeout = 10 }
--cputimer:add_signal('timeout', function() cpuwidget.text = cpu() end)
--cputimer:start()

-- }}}

--}}}

--{{{ 整合 绘制


-- XXX --------------------------------------------
-- 以下的 鼠标事件必须位于 for 循环之前，否则不能解析
-- [ 鼠标点击 对应的 tag 事件 ]--{{{
--------------------------------------------
taglist.buttons = awful.util.table.join(
    awful.button({ }, 1, awful.tag.viewonly),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ settings.modkey }, 1, awful.client.movetotag),
    awful.button({ settings.modkey }, 3, awful.client.toggletag),
    -- 鼠标滚轮，切换标签页 From : default
    awful.button({ }, 4, awful.tag.viewprev),
    awful.button({ }, 5, awful.tag.viewnext)
    )
--}}}

-- [ 鼠标点击 状态栏窗口列表  From ：default ]--{{{
--------------------------------------------
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if not c:isvisible() then
                                                  awful.tag.viewonly(c:tags()[1])
                                              end
                                              client.focus = c
                                              c:raise()
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
--}}}
-- XXX --------------------------------------------

for s = 1, screen.count() do

-- [ 虚拟桌面 promptbox / layout 图标 ]--{{{
--------------------------------------------
    -- Run 运行
    promptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })

    -- 当前虚拟桌面的窗口布局样式图标
    layoutbox[s] = awful.widget.layoutbox(s)
    layoutbox[s]:buttons(awful.util.table.join(
                         awful.button({ }, 1, function () awful.layout.inc(settings.layouts, 1) end),
                         awful.button({ }, 3, function () awful.layout.inc(settings.layouts, -1) end)
    ))

    -- 创建 标签页
    taglist[s] = awful.widget.taglist.new(s, awful.widget.taglist.label.all, taglist.buttons)

    -- 创建 tasklist
    mytasklist[s] = awful.widget.tasklist(function(c)
                                              return awful.widget.tasklist.label.currenttags(c, s)
                                          end, mytasklist.buttons)
--}}}

-- [ StatusBar ]--{{{
--------------------------------------------
    -- 整个 状态栏 布局定义
    statusbar[s] = awful.wibox(
    {
        position = 'top',
        height = '14',
        fg = beautiful.fg_normal,
        bg = beautiful.bg_normal,
        screen = s
    })
    -- 整个 状态栏 组建布局定义摆放顺序
    statusbar[s].widgets =
    {
        {
            taglist[s],
            layoutbox[s],
            promptbox[s],
            layout = awful.widget.layout.horizontal.leftright
        },
        -- From : default
        --s == 1 and systray or nil,
        systray,
        clockwidget,
        batwidget,
        memwidget,
        thermalwidget,
        -- 在 screen / tmux 整合了 loadavg 平时也不怎么看
        --loadavgwidget,
        mytasklist[s],
        -- 布局是从右向左依次渲染，tasklist - rmal -- mem -- bat -- clock -- systray
        layout = awful.widget.layout.horizontal.rightleft
    }
--}}}

end


--}}}

--}}}

-- {{{ Mouse bindings 鼠标点击事件

-- [ 空白桌面 鼠标点击 事件 ]--{{{
--------------------------------------------
root.buttons(awful.util.table.join(
    -- 右键菜单
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
--}}}

-- }}}

-- {{{ Key Bindings 快捷键

-- 全局快捷键--{{{
local globalkeys = awful.util.table.join(

-- 虚拟桌面--{{{
    awful.key({ settings.modkey, 'Control' }, 'r',     awesome.restart),
    awful.key({ settings.modkey, 'Shift'   }, 'q',     awesome.quit),

    awful.key({ settings.modkey            }, 'Left',  awful.tag.viewprev),
    awful.key({ settings.modkey            }, 'Right', awful.tag.viewnext),

    -- 在之前停留的虚拟桌面之间，快速切换
    awful.key({ settings.modkey,           }, 'Escape',awful.tag.history.restore),



--}}}

-- 程序 --{{{

    -- Run 启动程序
    awful.key({ settings.modkey            }, 'r',     function () promptbox[mouse.screen]:run() end),

    -- 打开终端     xterm
    awful.key({ settings.modkey            }, 'x',     function () awful.util.spawn("rox") end),
    awful.key({ settings.modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    -- 打开浏览器   web
    awful.key({ settings.modkey            }, 'w',     function () awful.util.spawn(settings.browser) end),





--}}}

-- [ 截图 ]--{{{
---------------------------------------------
-- Print 按键截图，依赖 scrot，截图保存到 ~/pic 目录
--awful.key({ }, "Print", function () awful.util.spawn("scrot -e 'mv $f ~/pic/ 2>/dev/null'") end),
--awful.key({ 'Alt' }, 'Print', function () awful.util.spawn("scrot -sb 'mv $f ~/pic/ 2>/dev/null'") end),
--awful.key({ 'Control' }, 'Print', function () awful.util.spawn("scrot -s 'mv $f ~/pic/ 2>/dev/null'") end),

--}}}

---- [ sdcv 词典 ]--{{{
-----------------------------------------------
---- From : http://linuxtoy.org/archives/awesome-窗口管理器——换种方式使用星际译王.html
---- 无论是用鼠标在 Firefox 里，还是用键盘在 Vim 里， 选中单词，按 Meta-d 就会在右上方弹出翻译结果
---- 手动输入单词时，按 Meta-Shift-d 会在任务栏弹出一个 Dict: 输入栏，输入后 "回车" 显示翻译结果
---- 可设置超时自动关闭翻译结果，也可再按 Meta-d 立即关闭翻译结果 ，用鼠标单击翻译结果也可以关闭
--
---- [ 取词查询 ]--{{{
----------------------------------------------
--awful.key({ settings.modkey }, "d", function ()
--    local f = io.popen("xsel -o")
--    local new_word = f:read("*a")
--    f:close()
--
--    if frame ~= nil then
--        naughty.destroy(frame)
--        frame = nil
--        if old_word == new_word then
--            return
--        end
--    end
--    old_word = new_word
--
--    local fc = ""
--    --local f  = io.popen("sdcv -n --utf8-output -u '牛津英汉双解美化版' "..new_word)
--    local f  = io.popen("sdcv -n --utf8-output -u '计算机词汇' "..new_word)
--    for line in f:lines() do
--        fc = fc .. line .. '\n'
--    end
--    f:close()
--    frame = naughty.notify({ text = fc, timeout = 10, width = 320 })
--end),
----}}}
--
---- [ 手动输入单词查询 ]--{{{
----------------------------------------------
--awful.key({ settings.modkey, "Shift" }, "d", function ()
--    awful.prompt.run({prompt = "Dict: "}, mypromptbox[mouse.screen].widget, function(cin_word)
--    -- awful.key({ settings.modkey            }, 'r',     function () promptbox[mouse.screen]:run() end),
--        naughty.destroy(frame)
--        if cin_word == "" then
--            return
--        end
--
--        local fc = ""
--        --local f  = io.popen("sdcv -n --utf8-output -u '牛津英汉双解美化版' "..cin_word)
--        local f  = io.popen("sdcv -n --utf8-output -u '计算机词汇' "..cin_word)
--
--        for line in f:lines() do
--            fc = fc .. line .. '\n'
--        end
--        f:close()
--        frame = naughty.notify({ text = fc, timeout = 10, width = 320 })
--    end, nil, awful.util.getdir("cache").."/dict")
--end),
----}}}
--
--
----}}}

-- 布局 焦点 大小--{{{

-- 在之前停留的窗口之间切换，要实现 Alt - Tab 要用 Mod4 - j / k
    awful.key({ settings.modkey,           }, 'Tab',  function ()
        awful.client.focus.history.previous()
        if client.focus then client.focus:raise() end
    end),

-- 窗口布局切换
    awful.key({ settings.modkey            }, 'space', function () awful.layout.inc(settings.layouts, 1) end),
    awful.key({ settings.modkey, 'Shift'   }, 'space', function () awful.layout.inc(settings.layouts, -1) end),

-- 上下布局--{{{
    -- 上下分布的窗口聚焦切换
    awful.key({ settings.modkey,           }, 'j',     function ()
        awful.client.focus.byidx( 1)
        if client.focus then client.focus:raise() end
    end),
    awful.key({ settings.modkey,           }, 'k',     function ()
        awful.client.focus.byidx(-1)
        if client.focus then client.focus:raise() end
    end),

    -- 上下分布的窗口桌面布局改变
    awful.key({ settings.modkey, 'Shift'   }, 'j',    function () awful.client.swap.byidx(1) end),
    awful.key({ settings.modkey, 'Shift'   }, 'k',    function () awful.client.swap.byidx(-1) end),
    awful.key({ settings.modkey, 'Control' }, 'j',    function () awful.screen.focus_relative(1) end),
    awful.key({ settings.modkey, 'Control' }, 'k',    function () awful.screen.focus_relative(-1) end),

--}}}

-- 左右布局--{{{
    -- 窗口尺寸大小调节
    awful.key({ settings.modkey            }, 'l',     function () awful.tag.incmwfact(0.025) end),
    awful.key({ settings.modkey            }, 'h',     function () awful.tag.incmwfact(-0.025) end),
    awful.key({ settings.modkey, 'Shift'   }, 'h',     function () awful.client.incwfact(0.05) end),
    awful.key({ settings.modkey, 'Shift'   }, 'l',     function () awful.client.incwfact(-0.05) end),
    awful.key({ settings.modkey, 'Control' }, 'h',     function () awful.tag.incnmaster(1) end),
    awful.key({ settings.modkey, 'Control' }, 'l',     function () awful.tag.incnmaster(-1) end),

--}}}

--}}}
    awful.key({ settings.modkey,           }, 'u',    awful.client.urgent.jumpto),

    awful.key({ }, '#121',  function () awful.util.spawn_with_shell('dvol -t') end),
    awful.key({ }, '#122',  function () awful.util.spawn_with_shell('dvol -d 2') end),
    awful.key({ }, '#123',  function () awful.util.spawn_with_shell('dvol -i 2') end)
)

--}}}

-- 窗口快捷键 [?]--{{{
local clientkeys = awful.util.table.join(

    -- 关闭
    awful.key({ settings.modkey            }, 'c',     function (c) c:kill() end),
    -- 全屏，隐藏 StatusBar
    awful.key({ settings.modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ settings.modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    -- 刷新
    awful.key({ settings.modkey, 'Shift'   }, 'r',     function (c) c:redraw() end),
    -- 移动到 [?]
    awful.key({ settings.modkey,           }, "o",      awful.client.movetoscreen                        ),
    -- 放置在最上层
    --awful.key({ settings.modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ settings.modkey            }, 't',     awful.client.togglemarked),
    -- 浮动
    awful.key({ settings.modkey, 'Control' }, 'space', awful.client.floating.toggle),
    -- 最小化
    awful.key({ settings.modkey,           }, "n",      function (c) c.minimized = not c.minimized    end),
    -- 最大化
    awful.key({ settings.modkey            }, 'm',
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)
--}}}

-- 和 /etc 配置相同 [?] 9 个虚拟桌面 --{{{

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- 切换 tags
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ settings.modkey }, '#' .. i + 9,
        function ()
            local screen = mouse.screen
            if tags[screen][i] then
                awful.tag.viewonly(tags[screen][i])
            end
        end),
        awful.key({ settings.modkey, 'Control' }, '#' .. i + 9,
        function ()
            local screen = mouse.screen
            if tags[screen][i] then
                awful.tag.viewtoggle(tags[screen][i])
            end
        end),
        awful.key({ settings.modkey, 'Shift' }, '#' .. i + 9,
        function ()
            if client.focus and tags[client.focus.screen][i] then
                awful.client.movetotag(tags[client.focus.screen][i])
            end
        end),
        awful.key({ settings.modkey, 'Control', 'Shift' }, '#' .. i + 9,
        function ()
            if client.focus and tags[client.focus.screen][i] then
                awful.client.toggletag(tags[client.focus.screen][i])
            end
        end)
    )
end

--}}}

local clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ settings.modkey }, 1, awful.mouse.client.move),
    awful.button({ settings.modkey }, 3, awful.mouse.client.resize)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules 特定程序 布局 / 虚拟桌面

awful.rules.rules =
{
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    -- 浮动窗口风格 程序
    { rule = { class = 'MPlayer' },
      properties = { floating = true } },
    { rule = { class = 'gimp' },
      properties = { floating = true } },
    -- 在虚拟桌面，排放指定的程序
    { rule = { class = 'firefox' },
      properties = { tag = tags[1][2] } },
    { rule = { class = 'rox' },
      properties = { tag = tags[1][4] } },
    { rule = { class = 'pcmanfm' },
      properties = { tag = tags[1][4] } },
    { rule = { class = 'pidgin' },
      properties = { tag = tags[1][4] } },
    -- 内建 透明规则 awesome wiki
    {rule = {class = "xterm"},
    properties = {opacity = 0.8} }

}

-- }}}

-- {{{ Signals

-- 当新的 client 启动时，调用的函数
client.add_signal('manage', function (c, startup)

    -- 添加 标题栏
    -- awful.titlebar.add(c, { modkey = modkey })

    -- Enable sloppy focus
    c:add_signal('mouse::enter', function (c)
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

    c.size_hints_honor = false
end)

client.add_signal('focus', function(c) c.border_color = beautiful.border_focus end)
client.add_signal('unfocus', function(c) c.border_color = beautiful.border_normal end)

-- }}}



-- Arch Wiki--{{{

-- Hide / show wibox in awesome 3
--awful.key({ modkey }, "b", function ()
--    mywibox[mouse.screen].visible = not mywibox[mouse.screen].visible
--end),


---- 音量--{{{
---- From : Arch Wiki 不是 awesome3 [?]
--key
--{
--    modkey = {"Mod1", "Control"}
--    key = "Up"
--    command = "spawn"
--    arg = "amixer sset Master,0 5%+"
--}
--key
--{
--    modkey = {"Mod1", "Control"}
--    key = "Down"
--    command = "spawn"
--    arg = "amixer sset Master,0 5%-"
--}
----}}}

-- 透明--{{{
-- 可行，桌面窗口之间切换，还可以。切换虚拟桌面，有些延迟

---- awesome3 透明，需要提前在 .xinirc 里面启动 xcommpgr &
---- 如果有关于 add_signal 错误提示, 使用 connect_signal 代替
--client.add_signal("focus",
--function(c)
--    c.border_color = beautiful.border_focus
--    c.opacity = 1
--end)
--client.add_signal("unfocus",
--function(c)
--    c.border_color = beautiful.border_normal
--    c.opacity = 0.7
--end)

--}}}

-- [ Expose / Revelation ]--{{{
---------------------------------------------
-- revelation 类 compiz 的 expose 平铺当前窗口功能
-- https://awesome.naquadah.org/wiki/Revelation
-- http://linuxtoy.org/archives/awesome-窗口管理器——缩略图技巧.html
-- 通过 xprop 命令可以查询某个窗口的 CLASS 值--}}}





--}}}

-- [ Autostart 自动运行程序 ]--{{{
---------------------------------------------

---- [ Ubuntu wiki ]--{{{
-----------------------------------------------
--autorun = true
--autorunApps = 
--{
--    "xterm",
--    "rox",
--    "pcmanfm",
--}
--if autorun then
--    for app = 1, #autorunApps do
--        awful.util.spawn(autorunApps[app])
--    end
--end
----}}}

---- [ ArchWiki ]--{{{
-----------------------------------------------
--do
--  local cmds = 
--  {
--    "firefox",
--    "mutt",
--  }
--
--  for _,i in pairs(cmds) do
--    awful.util.spawn(i)
--  end
--end

--function run_once(prg)
--  awful.util.spawn_with_shell("pgrep -u $USER -x " .. prg .. " || (" .. prg .. ")")
--end
--
--run_once("rox")
--run_once("pcmanfm")

----}}}

-- [ awesome wiki ]--{{{
---------------------------------------------
-- From : https://awesome.naquadah.org/wiki/Autostart

--function run_once(prg,arg_string,pname,screen)
--    if not prg then
--        do return nil end
--    end
--    if not pname then
--       pname = prg
--    end
--    if not arg_string then 
--        awful.util.spawn_with_shell("pgrep -f -u $USER -x '" .. pname .. "' || (" .. prg .. ")",screen)
--    else
--        awful.util.spawn_with_shell("pgrep -f -u $USER -x '" .. pname .. "' || (" .. prg .. " " .. arg_string .. ")",screen)
--    end
--end
--
--run_once("rox",nil,nil,4)
--run_once("xterm",nil,nil,1)
--run_once("pcmanfm",nil,nil,4)
----run_once("xscreensaver","-no-splash")
----run_once("wicd-client",nil,"/usr/bin/python2 -O /usr/share/wicd/gtk/wicd-client.py")


--}}}






--}}}

-- [  ]--{{{
---------------------------------------------










--}}}



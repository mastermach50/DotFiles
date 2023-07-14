local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi


local taglist_buttons = gears.table.join(
    awful.button({ }, 1, function(t) t:view_only() end),
    awful.button({ superkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ superkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end),
    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
    )

local tasklist_buttons = gears.table.join(
    awful.button({ }, 1, function (c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal(
                "request::activate",
                "tasklist",
                {raise = true}
            )
        end
    end),
    awful.button({ }, 3, function()
        awful.menu.client_list({ theme = { width = 250 } })
    end),
    awful.button({ }, 4, function ()
        awful.client.focus.byidx(1)
    end),
    awful.button({ }, 5, function ()
        awful.client.focus.byidx(-1)
    end))

awful.screen.connect_for_each_screen(function(s)

    -- Each screen has its own tag table.
    awful.tag(
        { " 1 Main "," 2 "," 3 "," 4 "," 5 "," 6 "," 7 "," 8 "," 9 "," 0 "},
        s,
        awful.layout.layouts[1]
    )

    -- Create a textclock widget
    text_clock = wibox.widget.textclock()

    -- Create systray widget
    systray = wibox.widget.systray()

    -- Create layout box widget
    s.layoutbox = awful.widget.layoutbox(s)
    s.layoutbox:buttons(gears.table.join(
        awful.button({ }, 1, function () awful.layout.inc( 1) end),
        awful.button({ }, 3, function () awful.layout.inc(-1) end),
        awful.button({ }, 4, function () awful.layout.inc( 1) end),
        awful.button({ }, 5, function () awful.layout.inc(-1) end)))

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons,
        style = {
            shape = gears.shape.rounded_rect,
        }
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons,
        style = {
            shape = gears.shape.rounded_rect,
        }
    }

    -- Create the wibox
    s.top_bar = awful.wibar({
        position = "top",
        screen = s,
        border_width = dpi(4),
        shape = gears.shape.rounded_rect,
        height = dpi(30)
    })

    -- Add widgets to the wibox
    s.top_bar:setup {

        layout = wibox.layout.align.horizontal,

        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            s.mytaglist,
        },

        s.mytasklist, -- Middle widget

        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            systray,
            text_clock,
            s.layoutbox,
        },
    }
end)
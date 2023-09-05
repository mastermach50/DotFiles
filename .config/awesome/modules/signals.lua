local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")

-- Initialize Theme File
beautiful.init(gears.filesystem.get_configuration_dir() .. "/current_theme.lua")


client.connect_signal("manage", function (c)
    -- Set client shape as rounded rectange when created
    if c.maximized or c.fullscreen then
        c.shape = gears.shape.rectangle
    else
        c.shape = gears.shape.rounded_rect
    end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

-- Change Border Colour Based on Wheather Client Is Active
client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- Set client shape as rounded rectange when geometry changes
client.connect_signal("request::geometry", function(c)
    if c.maximized or c.fullscreen then
        c.shape = gears.shape.rectangle
    else
        c.shape = gears.shape.rounded_rect
    end

end)
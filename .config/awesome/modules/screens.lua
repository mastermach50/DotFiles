local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")


-- Initialize Theme File
beautiful.init(gears.filesystem.get_configuration_dir() .. "/current_theme.lua")

-- The Wallpaper Setting Function
local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

-- Set Wallpaper on each Screen
awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)
end)
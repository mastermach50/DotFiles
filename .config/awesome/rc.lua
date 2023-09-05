-- █▄ ▄█ ▄▀▄ ▀█▀ █▄█ ██▀ █   █ ▀ ▄▀▀   ▄▀▄ █   █ █▄ ▄█   ▄▀▀ ▄▀▄ █▄ █ █▀
-- █ ▀ █ █▀█  █  █ █ █▄▄ ▀▄▀▄▀   ▄██   █▀█ ▀▄▀▄▀ █ ▀ █   ▀▄▄ ▀▄▀ █ ▀█ █▀

-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")

local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")


-- {{{ Variable Definitions
-- Default Terminal
terminal = "alacritty"
-- Default Editor
editor = os.getenv("EDITOR") or "nvim"
-- Editor Command
editor_cmd = terminal .. " -e " .. editor
-- }}}


-- Awesome Error Handler
require("modules.error_handler")

-- Client Rules
require("modules.rules")

-- Layouts
require("modules.layouts")

-- Signals
require("modules.signals")

-- Wibars
require("modules.wibars")

-- Screens
require("modules.screens")

-- Client Titlebars
require("modules.titlebars")


-- {{{ Keybindings
-- Import Keybindings
local allkeys = require("modules.keys")
-- Set Global Keys
root.keys(allkeys.global_keybindings)
-- Set Global Mouse Bindings
root.buttons(allkeys.global_mousebindings)
-- }}}


-- Run The Picom Compositor
-- awful.spawn("pkill picom")
awful.spawn("picom")
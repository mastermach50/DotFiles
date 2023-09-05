local awful = require("awful")
local gears = require("gears")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")

superkey = "Mod4"
altkey = "Mod1"

local allkeys = {}



-- +------------------+
-- |GLOBAL KEYBINDINGS|
-- +------------------+
allkeys.global_keybindings = gears.table.join(

    -- -----------------------------
    -- AwesomeWM Related Keybindings
    -- -----------------------------
    awful.key({ superkey, }, "s", hotkeys_popup.show_help,
            {description = "show help", group="AwesomeWM"}),
    -- awful.key({ superkey, }, "w", function () mymainmenu:show() end,
    --         {description = "show main menu", group = "AwesomeWM"}),
    awful.key({ superkey, "Control" }, "r", awesome.restart,
            {description = "reload awesome", group = "AwesomeWM"}),
    awful.key({ superkey, "Shift"   }, "q", awesome.quit,
            {description = "quit awesome", group = "AwesomeWM"}),

    -- -----------------------
    -- Tag Related Keybindings
    -- -----------------------
    awful.key({ superkey, }, "Left", awful.tag.viewprev,
            {description = "view previous", group = "Tag"}),
    awful.key({ superkey, }, "Right", awful.tag.viewnext,
            {description = "view next", group = "Tag"}),
    awful.key({ superkey, }, "Escape", awful.tag.history.restore,
            {description = "go back", group = "Tag"}),

    -- --------------------------
    -- Client Related Keybindings
    -- --------------------------
    awful.key({ superkey, }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "Client"}
    ),
    awful.key({ superkey, }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "Client"}
    ),
    awful.key({ superkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "Client"}),
    awful.key({ superkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "Client"}),
    awful.key({ superkey, }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "Client"}),
    awful.key({ superkey, }, "Tab",
            function ()
                awful.client.focus.history.previous()
                if client.focus then
                    client.focus:raise()
                end
            end,
            {description = "go back", group = "Client"}),
    awful.key({ superkey, "Control" }, "n",
            function ()
                local c = awful.client.restore()
                -- Focus restored client
                if c then
                  c:emit_signal(
                      "request::activate", "key.unminimize", {raise = true}
                  )
                end
            end,
            {description = "restore minimized", group = "Client"}),

    -- --------------------------
    -- Screen Related Keybindings
    -- --------------------------
    awful.key({ superkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "Screen"}),
    awful.key({ superkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "Screen"}),

    -- --------------------------
    -- Layout Related Keybindings
    -- --------------------------
    awful.key({ superkey, }, "space", function () awful.layout.inc( 1) end,
              {description = "select next", group = "Layout"}),
    awful.key({ superkey, "Shift"   }, "space", function () awful.layout.inc(-1) end,
              {description = "select previous", group = "Layout"}),
    awful.key({ superkey, }, "l", function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "Layout"}),
    awful.key({ superkey, }, "h", function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "Layout"}),
    awful.key({ superkey, "Shift"   }, "h", function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "Layout"}),
    awful.key({ superkey, "Shift"   }, "l", function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "Layout"}),
    awful.key({ superkey, "Control" }, "h", function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "Layout"}),
    awful.key({ superkey, "Control" }, "l", function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "Layout"}),

    -- -----------------------------
    -- Program Launching Keybindings
    -- -----------------------------
    awful.key({ superkey, }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "Launcher"}),
    awful.key({ superkey, altkey, }, "space", function () awful.spawn("rofi -show run") end,
              {description = "open rofi launcher", group = "Launcher"})

    -- -- Prompt
    -- awful.key({ superkey }, "r", function () awful.screen.focused().mypromptbox:run() end,
    --           {description = "run prompt", group = "launcher"}),

    -- awful.key({ superkey }, "x",
    --           function ()
    --               awful.prompt.run {
    --                 prompt       = "Run Lua code: ",
    --                 textbox      = awful.screen.focused().mypromptbox.widget,
    --                 exe_callback = awful.util.eval,
    --                 history_path = awful.util.get_cache_dir() .. "/history_eval"
    --               }
    --           end,
    --           {description = "lua execute prompt", group = "AwesomeWM"}),
    -- Menubar
    -- awful.key({ superkey }, "p", function() menubar.show() end,
    --           {description = "show the menubar", group = "launcher"})
    )

for i = 1, 10 do
    allkeys.global_keybindings = gears.table.join(allkeys.global_keybindings,

        -- -----------------------
        -- Tag Related Keybindings
        -- -----------------------
        -- View tag only.
        awful.key({ superkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "Tag"}),
        -- Toggle tag display.
        awful.key({ superkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "Tag"}),


        -- --------------------------
        -- Client Related Keybindings
        -- --------------------------
        -- Move client to tag.
        awful.key({ superkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "Client"}),
        -- Toggle tag on focused client.
        awful.key({ superkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "Client"})
    )
end

-- +--------------------+
-- |GLOBAL MOUSEBINDINGS|
-- +--------------------+
allkeys.global_mousebindings = gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
)



-- +------------------+
-- |CLIENT KEYBINDINGS|
-- +------------------+
allkeys.client_keybindings = gears.table.join(

    -- --------------------------
    -- Client Related Keybindings
    -- --------------------------
    awful.key({ superkey, }, "f",
            function (c)
                c.fullscreen = not c.fullscreen
                c:raise()
            end,
            {description = "toggle fullscreen", group = "Client"}),
    awful.key({ superkey, }, "q", function (c) c:kill() end,
              {description = "close", group = "Client"}),
    awful.key({ superkey, "Control" }, "f",  awful.client.floating.toggle,
              {description = "toggle floating", group = "Client"}),
    awful.key({ superkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "Client"}),
    awful.key({ superkey, }, "o",      function (c) c:move_to_screen() end,
              {description = "move to screen", group = "Client"}),
    awful.key({ superkey, }, "t",      function (c) c.ontop = not c.ontop end,
              {description = "toggle keep on top", group = "Client"}),
    awful.key({ superkey, }, "n", function (c) c.minimized = true end,
        {description = "minimize", group = "Client"}),
    awful.key({ superkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "Client"}),
    awful.key({ superkey, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "Client"}),
    awful.key({ superkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "Client"})
)

-- +--------------------+
-- |CLIENT MOUSEBINDINGS|
-- +--------------------+
allkeys.client_mousebindings = gears.table.join(
    -- ----------------------------
    -- Client Related Mousebindings
    -- ----------------------------
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ superkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ superkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)



return allkeys
local wezterm = require("wezterm")
local config = wezterm.config_builder()
local bar = wezterm.plugin.require("https://github.com/adriankarlen/bar.wezterm")
local sessionizer = wezterm.plugin.require("https://github.com/mikkasendke/sessionizer.wezterm")

-- Define project behaviors
local project_configs = {
    ["postimatic-backend"] = {
        scheme = "Catppuccin Mocha",
        panes = {
            -- Pane 1: Top Left (Backend API server)
            { cwd = ".", cmd = "pnpm docker:dev:build" },
            -- Pane 2: Top Right (Drizzle Database Studio)
            { cwd = ".", cmd = "pnpm db:studio" },
            -- Pane 3: Bottom Left (Stripe Webhook Listener)
            { cwd = ".", cmd = "stripe listen --forward-to localhost:4300/webhook/stripe" },
            -- Pane 4: Bottom Right (Frontend)
            { cwd = "../postimatic-frontend", cmd = "pnpm dev" }
        }
    }
}

-- font config
config.font = wezterm.font("MesloLGS Nerd Font Mono")
config.font_size = 16.0

-- color scheme
config.color_scheme = "Catppuccin Mocha"
config.colors = {
  -- cursor and the cursor style is set to Block
  cursor_bg = '#52ad70',
  -- Specifies the border color of the cursor when the cursor style is set to Block,
  -- or the color of the vertical or horizontal bar when the cursor style is set to
  -- Bar or Underline.
  cursor_border = '#52ad70',
}

-- window config
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.8
config.macos_window_background_blur = 30

-- tab config
bar.apply_to_config(config)

-- functions
-- Logic to automate the 4-pane layout
local function build_4_panes(window, pane, path)
    local folder_name = path:match("([^/]+)$")
    local custom = project_configs[folder_name]

    if custom and custom.scheme then
        window:set_config_overrides({ color_scheme = custom.scheme })
    end

    -- Create layout
    local top_left = pane
    local top_right = top_left:split({ direction = "Right", size = 0.5 })
    local bottom_left = top_left:split({ direction = "Bottom", size = 0.5 })
    local bottom_right = top_right:split({ direction = "Bottom", size = 0.5 })

    local panes = { top_left, top_right, bottom_left, bottom_right }

    -- Execute tasks
    for i, p in ipairs(panes) do
        local task = (custom and custom.panes[i]) or { cwd = ".", cmd = "clear" }
    
        -- Change %q to %s and remove the manual quotes to let the absolute path work
        local full_cmd = string.format("cd %s && cd %s && clear && %s\n", path, task.cwd, task.cmd)
        p:send_text(full_cmd)
    end
end

-- keybindings
config.keys = {
    -- Keep your CMD+D bindings here...
    {
        key = "d",
        mods = "CMD",
        action = wezterm.action.SplitPane({ direction = "Right" }),
    },
    -- Set command + shift + d to duplicate pane vertically
    {
        key = "d",
        mods = "CMD|SHIFT",
        action = wezterm.action.SplitPane({ direction = "Down" }),
    },
    -- Set command + p to open the project selector
    {
        key = "p",
        mods = "CMD",
        action = sessionizer.show({
            options = {
                title = "Postimatic",
                callback = function(window, pane, id, label)
                    build_4_panes(window, pane, id)
                end,
            },
            wezterm.home_dir .. "/Desktop/All/Projects/postimatic/postimatic-backend",
        }),
    },
}

wezterm.on("gui-startup", function(spawn_args)
  local _, _, window = wezterm.mux.spawn_window(spawn_args or {})
  window:gui_window():maximize()
end)

-- Try to load a local config file that is NOT tracked by git
local local_config_path = wezterm.config_dir .. "/local.lua"
local f = io.open(local_config_path, "r")
if f ~= nil then
    f:close()
    local local_config = dofile(local_config_path)
    -- This allows the local file to modify the config object
    if type(local_config) == "function" then
        local_config(config)
    end
end

return config
-- /* ---- 💫 https://github.com/Acacio28 ---- */
-- Main entry point for Hyprland Lua config

hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")

hl.on("hyprland.start", function()
    hl.exec_cmd(os.getenv("HOME") .. "/.config/hypr/initial-boot.sh")
    hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")
    hl.exec_cmd(os.getenv("HOME") .. "/.config/hypr/UserScripts/WallpaperRandom.sh")
    hl.exec_cmd("hyprpm reload -n")
end)

-- Plugin config: reapplied on every config.reloaded because a reload resets
-- plugin values to their defaults. The guards skip this while the plugins are
-- not loaded yet (they get loaded by `hyprpm reload -n` above, which triggers
-- another reload once they are in).
hl.on("config.reloaded", function()
    if hl.get_config("plugin:hyprexpo:columns") ~= nil then
        hl.config({
            plugin = {
                hyprexpo = {
                    columns          = 3,
                    gaps_in          = 5,
                    gaps_out         = 0,
                    bg_col           = "rgb(111111)",
                    workspace_method = "center current",
                    gesture_distance = 200,
                    cancel_key       = "escape",
                    show_cursor      = 1,
                },
            },
        })
    end
    if hl.get_config("plugin:hyprgrass:sensitivity") ~= nil then
        hl.config({
            plugin = {
                hyprgrass = { sensitivity = 1.0 },
            },
        })
    end
end)

dofile(os.getenv("HOME") .. "/.config/hypr/configs/Keybinds.lua")
dofile(os.getenv("HOME") .. "/.config/hypr/UserConfigs/Startup_Apps.lua")
dofile(os.getenv("HOME") .. "/.config/hypr/UserConfigs/ENVariables.lua")
dofile(os.getenv("HOME") .. "/.config/hypr/UserConfigs/Laptops.lua")
dofile(os.getenv("HOME") .. "/.config/hypr/UserConfigs/LaptopDisplay.lua")
dofile(os.getenv("HOME") .. "/.config/hypr/UserConfigs/WindowRules.lua")
dofile(os.getenv("HOME") .. "/.config/hypr/UserConfigs/UserDecorations.lua")
dofile(os.getenv("HOME") .. "/.config/hypr/hyprland-gui.lua")
dofile(os.getenv("HOME") .. "/.config/hypr/UserConfigs/UserAnimations.lua")
dofile(os.getenv("HOME") .. "/.config/hypr/UserConfigs/UserKeybinds.lua")
dofile(os.getenv("HOME") .. "/.config/hypr/UserConfigs/UserSettings.lua")
dofile(os.getenv("HOME") .. "/.config/hypr/UserConfigs/01-UserDefaults.lua")
require("monitors")
require("workspaces")

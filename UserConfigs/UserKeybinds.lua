mainMod = "SUPER"
scriptsDir = os.getenv("HOME") .. "/.config/hypr/scripts"
UserScripts = os.getenv("HOME") .. "/.config/hypr/UserScripts"
UserConfigs = os.getenv("HOME") .. "/.config/hypr/UserConfigs"

dofile(UserConfigs .. "/01-UserDefaults.lua")

hl.bind(mainMod .. " + D",            hl.dsp.exec_cmd("pkill rofi || true && rofi -show drun -modi drun,filebrowser,run,window"))
hl.bind(mainMod .. " + B",            hl.dsp.exec_cmd('xdg-open "https://"'))
hl.bind(mainMod .. " + Return",       hl.dsp.exec_cmd(term))
hl.bind(mainMod .. " + E",            hl.dsp.exec_cmd(files))
hl.bind("SUPER + SHIFT + P",          hl.dsp.exec_cmd("bash ~/.config/hypr/scripts/menu-simple.sh"))
hl.bind("SUPER + SHIFT + X",          hl.dsp.exec_cmd("hyprctl clients -j | jq -r '.[].address' | while read addr; do hyprctl dispatch closewindow address:$addr; done"))

hl.bind(mainMod .. " + H",            hl.dsp.exec_cmd(scriptsDir .. "/KeyHints.sh"))
hl.bind(mainMod .. " + ALT + R",      hl.dsp.exec_cmd(scriptsDir .. "/Refresh.sh"))
hl.bind(mainMod .. " + ALT + E",      hl.dsp.exec_cmd(scriptsDir .. "/RofiEmoji.sh"))
hl.bind(mainMod .. " + S",            hl.dsp.exec_cmd(scriptsDir .. "/RofiSearch.sh"))
hl.bind(mainMod .. " + CTRL + S",     hl.dsp.exec_cmd("rofi -show window"))
hl.bind(mainMod .. " + ALT + O",      hl.dsp.exec_cmd(scriptsDir .. "/ChangeBlur.sh"))
hl.bind(mainMod .. " + SHIFT + G",    hl.dsp.exec_cmd(scriptsDir .. "/GameMode.sh"))
hl.bind(mainMod .. " + ALT + L",      hl.dsp.exec_cmd(scriptsDir .. "/ChangeLayout.sh"))
hl.bind(mainMod .. " + ALT + V",      hl.dsp.exec_cmd(scriptsDir .. "/ClipManager.sh"))
hl.bind(mainMod .. " + CTRL + R",     hl.dsp.exec_cmd(scriptsDir .. "/RofiThemeSelector.sh"))
hl.bind(mainMod .. " + CTRL + SHIFT + R", hl.dsp.exec_cmd("pkill rofi || true && " .. scriptsDir .. "/RofiThemeSelector-modified.sh"))
hl.bind(mainMod .. " + X",            hl.dsp.exec_cmd("chromium"))
hl.bind(mainMod .. " + SHIFT + F",    hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + CTRL + F",     hl.dsp.window.fullscreen({ mode = 1 }))
hl.bind(mainMod .. " + SPACE",        hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + ALT + SPACE",  hl.dsp.exec_cmd("hyprctl dispatch workspaceopt allfloat"))
hl.bind(mainMod .. " + SHIFT + Return", hl.dsp.exec_cmd(scriptsDir .. "/Dropterminal.sh " .. term))

hl.bind(mainMod .. " + ALT + mouse_down", hl.dsp.exec_cmd('hyprctl keyword cursor:zoom_factor "$(hyprctl getoption cursor:zoom_factor | awk \'NR==1 {factor = $2; if (factor < 1) {factor = 1}; print factor * 2.0}\')"'))
hl.bind(mainMod .. " + ALT + mouse_up",   hl.dsp.exec_cmd('hyprctl keyword cursor:zoom_factor "$(hyprctl getoption cursor:zoom_factor | awk \'NR==1 {factor = $2; if (factor < 1) {factor = 1}; print factor / 2.0}\')"'))

hl.bind(mainMod .. " + CTRL + ALT + B", hl.dsp.exec_cmd("pkill -SIGUSR1 waybar"))
hl.bind(mainMod .. " + CTRL + B",       hl.dsp.exec_cmd(scriptsDir .. "/WaybarStyles.sh"))
hl.bind(mainMod .. " + ALT + B",        hl.dsp.exec_cmd(scriptsDir .. "/WaybarLayout.sh"))
hl.bind(mainMod .. " + SHIFT + B",      hl.dsp.exec_cmd(os.getenv("HOME") .. "/.config/waybar/switch_theme.sh"))

hl.bind(mainMod .. " + N", hl.dsp.exec_cmd(scriptsDir .. "/Hyprsunset.sh toggle"))

hl.bind(mainMod .. " + SHIFT + M",    hl.dsp.exec_cmd(UserScripts .. "/RofiBeats.sh"))
hl.bind(mainMod .. " + W",            hl.dsp.exec_cmd(UserScripts .. "/WallpaperSelect.sh"))
hl.bind(mainMod .. " + SHIFT + W",    hl.dsp.exec_cmd(UserScripts .. "/WallpaperEffects.sh"))
hl.bind(mainMod .. " + R",            hl.dsp.exec_cmd(UserScripts .. "/WallpaperRandom.sh"))
hl.bind(mainMod .. " + CTRL + O",     hl.dsp.exec_cmd("hyprctl setprop active opaque toggle"))
hl.bind(mainMod .. " + SHIFT + K",    hl.dsp.exec_cmd(scriptsDir .. "/KeyBinds.sh"))
hl.bind(mainMod .. " + SHIFT + A",    hl.dsp.exec_cmd(scriptsDir .. "/Animations.sh"))
hl.bind(mainMod .. " + SHIFT + O",    hl.dsp.exec_cmd(UserScripts .. "/ZshChangeTheme.sh"))
hl.bind("ALT_L + SHIFT_L",           hl.dsp.exec_cmd(scriptsDir .. "/SwitchKeyboardLayout.sh"), { locked = true, non_consuming = true })
hl.bind("SHIFT_L + ALT_L",           hl.dsp.exec_cmd(scriptsDir .. "/Tak0-Per-Window-Switch.sh"), { locked = true, non_consuming = true })
hl.bind(mainMod .. " + ALT + C",     hl.dsp.exec_cmd(UserScripts .. "/RofiCalc.sh"))

hl.bind(mainMod .. " + CTRL + F9",  hl.dsp.workspace.move({ monitor = "l" }))
hl.bind(mainMod .. " + CTRL + F10", hl.dsp.workspace.move({ monitor = "r" }))
hl.bind(mainMod .. " + CTRL + F11", hl.dsp.workspace.move({ monitor = "u" }))
hl.bind(mainMod .. " + CTRL + F12", hl.dsp.workspace.move({ monitor = "d" }))

hl.bind("SUPER + A", hl.dsp.exec_cmd("hyprctl dispatch hyprexpo:expo toggle"))

-- hyprgrass 3-finger swipe gestures (set after plugin loads)
hl.on("hyprland.start", function()
    hl.exec_cmd('hyprctl keyword plugin:hyprgrass:hyprgrass-bind ", swipe:3:r, workspace, +1"')
    hl.exec_cmd('hyprctl keyword plugin:hyprgrass:hyprgrass-bind ", swipe:3:l, workspace, -1"')
end)

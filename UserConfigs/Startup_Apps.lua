-- /* ---- 💫 https://github.com/Acacio28 ---- */
local scriptsDir = os.getenv("HOME") .. "/.config/hypr/scripts"
local UserScripts = os.getenv("HOME") .. "/.config/hypr/UserScripts"
local wallDIR = os.getenv("HOME") .. "/Pictures/wallpapers"
local lock = scriptsDir .. "/LockScreen.sh"
local SwwwRandom = UserScripts .. "/WallpaperAutoChange.sh"
local livewallpaper = ""

hl.on("hyprland.start", function()
    hl.exec_cmd("/usr/lib/xdg-desktop-portal")
    hl.exec_cmd("swww-daemon --format xrgb && swww img \"$(cat ~/.cache/wal/wal)\" && wallust run \"$(cat ~/.cache/wal/wal)\"")
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd(scriptsDir .. "/Dropterminal.sh kitty &")
    hl.exec_cmd(scriptsDir .. "/Polkit.sh")
    hl.exec_cmd("nm-applet --indicator")
    hl.exec_cmd("swaync")
    hl.exec_cmd("blueman-applet")
    hl.exec_cmd("waybar")
    hl.exec_cmd("qs")
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("/usr/lib/xdg-desktop-portal-kde")
    hl.exec_cmd(os.getenv("HOME") .. "/.config/hypr/scripts/NotifySound.sh")
end)

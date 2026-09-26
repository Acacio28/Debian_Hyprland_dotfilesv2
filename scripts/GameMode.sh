#!/bin/bash
# /* ---- 💫 https://github.com/Acacio28 💫 ---- */  ##
# Game Mode. Turning off all animations
# hyprctl keyword no longer works on the lua config: use hyprctl eval

notif="$HOME/.config/swaync/images/ja.png"
SCRIPTSDIR="$HOME/.config/hypr/scripts"


# animations:enabled is a bool on the lua config ("true"/"false"), not an int
HYPRGAMEMODE=$(hyprctl -j getoption animations:enabled | jq -r '.bool')
if [ "$HYPRGAMEMODE" = "true" ] ; then
    hyprctl eval 'hl.config({
        animations = { enabled = false },
        decoration = { shadow = { enabled = false }, blur = { enabled = false }, rounding = 0 },
        general    = { gaps_in = 0, gaps_out = 0, border_size = 1 },
    })'
    hyprctl eval 'hl.window_rule({ name = "gamemode", match = { class = ".*" }, opacity = "1 override 1 override 1 override" })'
    swww kill
    notify-send -e -u low -i "$notif" " Gamemode:" " enabled"
    exit
else
	swww-daemon --format xrgb && swww img "$HOME/.config/rofi/.current_wallpaper" &
	sleep 0.1
	${SCRIPTSDIR}/WallustSwww.sh
	sleep 0.5
  hyprctl reload
	${SCRIPTSDIR}/Refresh.sh
    notify-send -e -u normal -i "$notif" " Gamemode:" " disabled"
    exit
fi
hyprctl reload

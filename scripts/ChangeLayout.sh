#!/bin/bash
# /* ---- 💫 https://github.com/Acacio28 💫 ---- */  ##
# for changing Hyprland Layouts (Master or Dwindle) on the fly
# hyprctl keyword no longer works on the lua config: use hyprctl eval

notif="$HOME/.config/swaync/images/ja.png"

LAYOUT=$(hyprctl -j getoption general:layout | jq -r '.str' | sed 's/"//g')

case $LAYOUT in
"master")
	hyprctl eval 'hl.config({ general = { layout = "dwindle" } }); hl.unbind("SUPER + J"); hl.unbind("SUPER + K"); hl.unbind("SUPER + O"); hl.bind("SUPER + J", hl.dsp.layout("cyclenext")); hl.bind("SUPER + K", hl.dsp.layout("cycleprev")); hl.bind("SUPER + O", hl.dsp.layout("togglesplit"))'
	notify-send -e -u low -i "$notif" " Dwindle Layout"
	;;
"dwindle")
	hyprctl eval 'hl.config({ general = { layout = "master" } }); hl.unbind("SUPER + J"); hl.unbind("SUPER + K"); hl.unbind("SUPER + O"); hl.bind("SUPER + J", hl.dsp.layout("cyclenext")); hl.bind("SUPER + K", hl.dsp.layout("cycleprev"))'
	notify-send -e -u low -i "$notif" " Master Layout"
	;;
*) ;;

esac

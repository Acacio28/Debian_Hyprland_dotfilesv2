#!/bin/bash
# /* ---- 💫 https://github.com/Acacio28 💫 ---- */  ##
# Airplane Mode. Turning on or off all wifi using rfkill. 

notif="$HOME/.config/swaync/images/ja.png"

# rfkill lives in /usr/sbin which is often missing from the Hyprland session PATH
rfkill_bin="$(command -v rfkill || true)"
[ -z "$rfkill_bin" ] && [ -x /usr/sbin/rfkill ] && rfkill_bin=/usr/sbin/rfkill
[ -z "$rfkill_bin" ] && rfkill_bin=/bin/rfkill
if [ -z "$rfkill_bin" ] || [ ! -x "$rfkill_bin" ]; then
    notify-send -u critical "Airplane" "rfkill not found"
    exit 1
fi

# Check if any wireless device is blocked
wifi_blocked=$("$rfkill_bin" list wifi | grep -o "Soft blocked: yes")

if [ -n "$wifi_blocked" ]; then
    "$rfkill_bin" unblock wifi
    notify-send -u low -i "$notif" " Airplane" " mode: OFF"
else
    "$rfkill_bin" block wifi
    notify-send -u low -i "$notif" " Airplane" " mode: ON"
fi

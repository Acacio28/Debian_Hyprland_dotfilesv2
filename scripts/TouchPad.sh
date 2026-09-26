#!/bin/bash
# /* ---- 💫 https://github.com/Acacio28 💫 ---- */  ##
# For disabling touchpad.
# Uses hyprctl eval + hl.device (hyprctl keyword no longer works on the lua config)
# use hyprctl devices to get your system touchpad device name
# source https://github.com/hyprwm/Hyprland/discussions/4283?sort=new#discussioncomment-8648109

notif="$HOME/.config/swaync/images/ja.png"

export STATUS_FILE="$XDG_RUNTIME_DIR/touchpad.status"

TOUCHPAD=$(hyprctl -j devices | jq -r '[.mice[] | select(.name | test("touchpad$"; "i"))] | first | .name // empty')

set_touchpad() {
    if [ -z "$TOUCHPAD" ]; then
        notify-send -u low -i "$notif" " Touchpad" " device not found"
        return 1
    fi
    hyprctl eval "hl.device({ name = \"$TOUCHPAD\", enabled = $1 })"
}

enable_touchpad() {
    printf "true" >"$STATUS_FILE"
    notify-send -u low -i $notif  " Enabling" " touchpad"
    set_touchpad true
}

disable_touchpad() {
    printf "false" >"$STATUS_FILE"
    notify-send -u low -i $notif " Disabling" " touchpad"
    set_touchpad false
}

if ! [ -f "$STATUS_FILE" ]; then
  enable_touchpad
else
  if [ $(cat "$STATUS_FILE") = "true" ]; then
    disable_touchpad
  elif [ $(cat "$STATUS_FILE") = "false" ]; then
    enable_touchpad
  fi
fi

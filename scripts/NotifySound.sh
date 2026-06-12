#!/usr/bin/env bash
dbus-monitor "interface='org.freedesktop.Notifications',member='Notify'" |
while read -r line; do
    if echo "$line" | grep -q "member=Notify"; then
        paplay /usr/share/sounds/freedesktop/stereo/complete.oga &
    fi
done

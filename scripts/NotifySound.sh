#!/usr/bin/env bash
dbus-monitor "interface='org.freedesktop.Notifications',member='Notify'" |
while read -r line; do
    if echo "$line" | grep -q "member=Notify"; then
        NOTIF_SOUND=false
        while read -r line2; do
            if [[ "$line2" =~ string\ \"(.+)\" ]]; then
                TEXT="${BASH_REMATCH[1]}"
                if echo "$TEXT" | grep -qi "whatsapp"; then
                    NOTIF_SOUND=true
                    break
                fi
            fi
            if echo "$line2" | grep -qP "^\s*(uint32|int32|boolean|double|array|dict|struct)"; then
                continue
            fi
            if echo "$line2" | grep -qP "^\s*(method|signal|reply|error)"; then
                break
            fi
        done
        if $NOTIF_SOUND; then
            paplay /usr/share/sounds/freedesktop/stereo/complete.oga &
        fi
    fi
done

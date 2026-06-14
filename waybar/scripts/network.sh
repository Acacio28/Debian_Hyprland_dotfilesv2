#!/bin/bash

wifi_status=$(nmcli -t -f WIFI g)
wifi_ssid=$(nmcli -t -f ACTIVE,SSID dev wifi | grep '^yes' | cut -d: -f2)
wifi_signal=$(nmcli -t -f ACTIVE,SIGNAL dev wifi | grep '^yes' | cut -d: -f2)

if [ "$wifi_status" = "enabled" ] && [ -n "$wifi_ssid" ]; then
    echo "{\"text\": \" $wifi_ssid\", \"tooltip\": \"Signal: $wifi_signal%\", \"class\": \"connected\"}"
elif [ "$wifi_status" = "enabled" ]; then
    echo "{\"text\": \"󰤮\", \"tooltip\": \"WiFi On - Not Connected\", \"class\": \"disconnected\"}"
else
    echo "{\"text\": \"󰤭\", \"tooltip\": \"WiFi Disabled\", \"class\": \"disabled\"}"
fi

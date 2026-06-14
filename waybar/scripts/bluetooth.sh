#!/bin/bash

bluetooth_status=$(bluetoothctl show | grep "Powered: yes" > /dev/null && echo "on" || echo "off")
connected_devices=$(bluetoothctl devices Connected | wc -l)

if [ "$bluetooth_status" = "on" ] && [ "$connected_devices" -gt 0 ]; then
    device_name=$(bluetoothctl devices Connected | head -1 | cut -d ' ' -f 3-)
    echo "{\"text\": \" $device_name\", \"class\": \"connected\"}"
elif [ "$bluetooth_status" = "on" ]; then
    echo "{\"text\": \"\", \"class\": \"on\"}"
else
    echo "{\"text\": \"\", \"class\": \"off\"}"
fi

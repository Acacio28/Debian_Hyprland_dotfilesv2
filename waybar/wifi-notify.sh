#!/bin/bash
SSID="$1"
STATUS="$2"

if [ "$STATUS" = "connected" ]; then
    notify-send "Rede konektadu" "Ita konekta ba: $SSID"
else
    notify-send "Rede la konekta" "Ita la konekta ba rede"
fi


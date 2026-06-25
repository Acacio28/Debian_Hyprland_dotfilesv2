#!/bin/bash
# Build and install Hyprland v0.55.4 from source with Lua patches

LOG="Install-Logs/install-$(date +%d-%H%M%S).log"

if command -v Hyprland &>/dev/null; then
    echo "Hyprland is already installed. Skipping build."
    exit 0
fi

if [ ! -d "/tmp/Hyprland" ]; then
    git clone --recursive -b main https://github.com/Acacio28/Hyprland /tmp/Hyprland 2>&1 | tee -a "$LOG"
fi

cd /tmp/Hyprland
make all 2>&1 | tee -a "$LOG" && sudo make install 2>&1 | tee -a "$LOG"

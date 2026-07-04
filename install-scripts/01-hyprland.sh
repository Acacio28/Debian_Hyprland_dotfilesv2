#!/bin/bash
# Build and install Hyprland v0.55.4 from source with Lua patches

mkdir -p Install-Logs
LOG="Install-Logs/install-$(date +%d-%H%M%S).log"

if command -v Hyprland &>/dev/null; then
    echo "Hyprland is already installed. Skipping build."
    exit 0
fi

rm -rf /tmp/Hyprland
git clone --recursive -b main https://github.com/Acacio28/Hyprland /tmp/Hyprland 2>&1 | tee -a "$LOG"

cd /tmp/Hyprland
make all 2>&1 | tee -a "$LOG" || { echo "Build failed. Check $LOG"; exit 1; }
sudo make install 2>&1 | tee -a "$LOG" || { echo "Install failed. Check $LOG"; exit 1; }

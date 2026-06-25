#!/bin/bash
# Setup hyprpm and install plugins

LOG="Install-Logs/install-$(date +%d-%H%M%S).log"

if ! command -v hyprpm &>/dev/null; then
    echo "hyprpm not found. Ensure Hyprland is installed first."
    exit 1
fi

hyprpm update 2>&1 | tee -a "$LOG"
hyprpm add https://github.com/horriblename/hyprgrass 2>&1 | tee -a "$LOG" || true
hyprpm add https://github.com/sandwichfarm/hyprexpo 2>&1 | tee -a "$LOG" || true
hyprpm add https://github.com/hyprwm/hyprland-plugins 2>&1 | tee -a "$LOG" || true
hyprpm enable hyprgrass 2>&1 | tee -a "$LOG" || true
hyprpm enable hyprexpo 2>&1 | tee -a "$LOG" || true
hyprpm reload -n 2>&1 | tee -a "$LOG"

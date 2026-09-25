#!/bin/bash
# Base tools (Hyprland comes from apt, no source build needed)

mkdir -p Install-Logs
LOG="Install-Logs/install-$(date +%d-%H%M%S).log"

DEPS=(
    git curl ca-certificates pciutils
    g++ make cmake ninja-build pkg-config
)

for pkg in "${DEPS[@]}"; do
    if ! dpkg -l 2>/dev/null | grep -q "^ii.*$pkg"; then
        sudo apt install -y --no-install-recommends "$pkg" 2>&1 | tee -a "$LOG" || true
    fi
done

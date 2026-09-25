#!/bin/bash
# Base tools (Hyprland comes from apt, no source build needed)

mkdir -p Install-Logs
LOG="Install-Logs/install-$(date +%d-%H%M%S).log"

DEPS=(
    git curl ca-certificates pciutils
    g++ gcc make cmake ninja-build pkg-config python3-dev liblz4-dev cpio
    wayland-protocols libwayland-dev
)

for pkg in "${DEPS[@]}"; do
    # exact package-name check (dpkg -l grep also matches descriptions, e.g. "profiles" hits rofi)
    if ! dpkg -s "$pkg" 2>/dev/null | grep -q "Status: install ok installed"; then
        sudo apt install -y --no-install-recommends "$pkg" 2>&1 | tee -a "$LOG" || true
    fi
done

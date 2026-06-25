#!/bin/bash
# Build dependencies for Hyprland ecosystem

LOG="Install-Logs/install-$(date +%d-%H%M%S).log"

DEPS=(
    git meson cmake ninja-build g++ pkg-config
    libwayland-dev libxkbcommon-dev libcairo2-dev libpango1.0-dev
    libglib2.0-dev libdrm-dev libgbm-dev libinput-dev libudev-dev
    libxcb1-dev libxcb-dri3-dev libxcb-present-dev libxcb-composite0-dev
    libxcb-ewmh-dev libxcb-icccm4-dev libxcb-render-util0-dev
    libxcb-res0-dev libxcb-xinput-dev libxcb-xfixes0-dev libxcb-shape0-dev
    libxcb-randr0-dev libhyprutils-dev libpipewire-0.3-dev
    libspa-0.2-dev libpam0g-dev libxrandr-dev libxinerama-dev
    libseat-dev libhwloc-dev liblz4-dev
)

for pkg in "${DEPS[@]}"; do
    if ! dpkg -l | grep -q "^ii.*$pkg"; then
        sudo apt install -y --no-install-recommends "$pkg" 2>&1 | tee -a "$LOG" || true
    fi
done

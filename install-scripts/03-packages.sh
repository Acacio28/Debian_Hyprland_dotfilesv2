#!/bin/bash
# Install Wayland/app packages

LOG="Install-Logs/install-$(date +%d-%H%M%S).log"

PACKAGES=(
    waybar rofi swaync kitty nautilus swww
    fonts-noto fonts-noto-color-emoji fonts-jetbrains-mono fonts-firacode
    wlogout wofi tofi btop cava fastfetch grim slurp swappy
    wl-clipboard cliphist brightnessctl pamixer playerctl pavucontrol
    network-manager nm-applet blueman polkit-kde-agent-1 jq imagemagick
    xdg-desktop-portal-hyprland xdg-utils qt5ct qt6ct nwg-look wallust
    python3-requests python3-pip
)

for pkg in "${PACKAGES[@]}"; do
    if ! dpkg -l | grep -q "^ii.*$pkg"; then
        sudo apt install -y --no-install-recommends "$pkg" 2>&1 | tee -a "$LOG" || true
    fi
done

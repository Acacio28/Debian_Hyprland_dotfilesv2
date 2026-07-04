#!/bin/bash
# Install Wayland/app packages

mkdir -p Install-Logs
LOG="Install-Logs/install-$(date +%d-%H%M%S).log"

PACKAGES=(
    waybar rofi swaync kitty nautilus swww
    fonts-noto fonts-noto-color-emoji fonts-jetbrains-mono fonts-firacode
    wlogout tofi btop cava fastfetch grim slurp swappy
    wl-clipboard cliphist brightnessctl pamixer playerctl pavucontrol
    network-manager nm-applet blueman polkit-kde-agent-1 jq imagemagick
    xdg-desktop-portal-hyprland xdg-utils qt5ct qt6ct
    python3-requests python3-pip
)

for pkg in "${PACKAGES[@]}"; do
    if ! dpkg -l 2>/dev/null | grep -q "^ii.*$pkg"; then
        echo "Installing $pkg..."
        sudo apt install -y --no-install-recommends "$pkg" 2>&1 | tee -a "$LOG" || echo "Warning: $pkg could not be installed (may not be in repo)"
    fi
done

# Install wallust from pip if apt doesn't have it
if ! command -v wallust &>/dev/null; then
    echo "Installing wallust via pip..."
    pip install wallust --break-system-packages 2>&1 | tee -a "$LOG" || true
fi

#!/bin/bash
# Install Wayland/app packages

mkdir -p Install-Logs
LOG="Install-Logs/install-$(date +%d-%H%M%S).log"

PACKAGES=(
    waybar rofi sway-notification-center kitty nautilus
    fonts-noto fonts-noto-color-emoji fonts-jetbrains-mono fonts-firacode
    wlogout tofi btop cava fastfetch grim slurp swappy
    wl-clipboard cliphist brightnessctl pamixer playerctl pavucontrol
    network-manager network-manager-gnome blueman polkit-kde-agent-1 jq imagemagick
    xdg-desktop-portal-hyprland xdg-utils qt5ct qt6ct libnotify-bin
    python3-requests python3-pip
)

for pkg in "${PACKAGES[@]}"; do
    # Already usable (binary may come from outside dpkg, e.g. manual install)
    if command -v "$pkg" &>/dev/null; then
        continue
    fi
    if ! dpkg -l 2>/dev/null | grep -q "^ii.*$pkg"; then
        echo "Installing $pkg..."
        sudo apt install -y --no-install-recommends "$pkg" 2>&1 | tee -a "$LOG" || echo "Warning: $pkg could not be installed (may not be in repo)"
    fi
done

# Install wallust + pywal from pip (not in Debian repos)
if ! command -v wallust &>/dev/null || ! command -v wal &>/dev/null; then
    echo "Installing wallust + pywal via pip..."
    sudo pip3 install --break-system-packages wallust pywal 2>&1 | tee -a "$LOG" || true
fi

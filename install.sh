#!/usr/bin/env bash
#
# install.sh - Debian/Ubuntu Hyprland Dotfiles Installer
# Repo: https://github.com/Akashio28/Debian_Hyprland_dotfilesv2
#
# Based on JaKooLit's Hyprland-Dots, adapted for Hyprland v0.55.x
#
# Usage:
#   git clone https://github.com/Akashio28/Debian_Hyprland_dotfilesv2.git
#   cd Debian_Hyprland_dotfilesv2
#   chmod +x install.sh
#   ./install.sh
#

set -e

# ----------------------------------------------------------------
# Banner
# ----------------------------------------------------------------
clear
cat << "EOF"
 █████╗ ██╗  ██╗ █████╗ ███████╗██╗  ██╗██╗ ██████╗ 
██╔══██╗██║ ██╔╝██╔══██╗██╔════╝██║  ██║██║██╔═══██╗
███████║█████╔╝ ███████║███████╗███████║██║██║   ██║
██╔══██║██╔═██╗ ██╔══██║╚════██║██╔══██║██║██║   ██║
██║  ██║██║  ██╗██║  ██║███████║██║  ██║██║╚██████╔╝
╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝ ╚═════╝ 
EOF
echo ""
echo "          Debian Hyprland Dotfiles v2"
echo "       by Akashio28 (Acacio) - github.com/Akashio28"
echo ""
sleep 1

# ----------------------------------------------------------------
# Colors
# ----------------------------------------------------------------
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

info()  { echo -e "${GREEN}[INFO]${NC} $1"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }

# ----------------------------------------------------------------
# Pre-flight checks
# ----------------------------------------------------------------
if [ "$EUID" -eq 0 ]; then
    error "Please do not run this script as root/sudo. Run as a normal user."
    exit 1
fi

if ! command -v apt &> /dev/null; then
    error "This script only supports Debian/Ubuntu (apt-based) systems."
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"
HYPR_DIR="$CONFIG_DIR/hypr"
BACKUP_DIR="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"

# ----------------------------------------------------------------
# 1. Update system
# ----------------------------------------------------------------
info "Updating package lists..."
sudo apt update

# ----------------------------------------------------------------
# 2. Install Hyprland and core dependencies
# ----------------------------------------------------------------
info "Installing Hyprland and core dependencies..."
sudo apt install -y \
    hyprland \
    hyprpaper \
    hypridle \
    hyprlock \
    hyprcursor \
    hyprpicker \
    xdg-desktop-portal-hyprland \
    waybar \
    rofi \
    swaync \
    swww \
    kitty \
    thunar \
    polkit-kde-agent-1 \
    network-manager-gnome \
    blueman \
    pavucontrol \
    playerctl \
    brightnessctl \
    grim \
    slurp \
    swappy \
    wl-clipboard \
    cliphist \
    jq \
    wlogout \
    nwg-look \
    qt5ct \
    qt6ct \
    git \
    curl \
    wget \
    unzip \
    build-essential \
    cmake \
    meson \
    ninja-build \
    pkg-config

# Note: some packages (e.g. swww, hyprpicker) may not be in default
# Debian/Ubuntu repos depending on your release. If apt fails on a
# package, install it manually or build from source, then re-run
# this script (it is safe to re-run).

# ----------------------------------------------------------------
# 3. Install hyprpm plugin build dependencies
# ----------------------------------------------------------------
info "Installing plugin build dependencies (hyprpm)..."
sudo apt install -y \
    libwayland-dev \
    wayland-protocols \
    libxkbcommon-dev \
    libpixman-1-dev \
    libdrm-dev \
    libgbm-dev \
    libinput-dev

# ----------------------------------------------------------------
# 4. Backup existing config
# ----------------------------------------------------------------
if [ -d "$HYPR_DIR" ]; then
    warn "Existing ~/.config/hypr found. Backing up to $BACKUP_DIR/hypr"
    mkdir -p "$BACKUP_DIR"
    mv "$HYPR_DIR" "$BACKUP_DIR/hypr"
fi

# Also backup related app configs that this dotfiles repo manages,
# only if they exist
for d in waybar rofi swaync kitty wlogout wallust; do
    if [ -d "$CONFIG_DIR/$d" ]; then
        warn "Existing ~/.config/$d found. Backing up to $BACKUP_DIR/$d"
        mkdir -p "$BACKUP_DIR"
        mv "$CONFIG_DIR/$d" "$BACKUP_DIR/$d"
    fi
done

# ----------------------------------------------------------------
# 5. Copy dotfiles into ~/.config
# ----------------------------------------------------------------
info "Copying configuration files to ~/.config..."

mkdir -p "$CONFIG_DIR"
cp -r "$SCRIPT_DIR/hypr" "$HYPR_DIR"

# If this repo also contains other app configs at its root
# (waybar, rofi, etc.), copy those too
for d in waybar rofi swaync kitty wlogout wallust; do
    if [ -d "$SCRIPT_DIR/$d" ]; then
        info "Copying $d config..."
        cp -r "$SCRIPT_DIR/$d" "$CONFIG_DIR/$d"
    fi
done

# Make scripts executable
chmod +x "$HYPR_DIR"/scripts/*.sh 2>/dev/null || true
chmod +x "$HYPR_DIR"/UserScripts/*.sh 2>/dev/null || true
chmod +x "$HYPR_DIR"/initial-boot.sh 2>/dev/null || true

# ----------------------------------------------------------------
# 6. Install hyprpm plugins
# ----------------------------------------------------------------
info "Setting up hyprpm and installing plugins..."

hyprpm update || warn "hyprpm update failed, continuing..."

# hyprgrass - touchscreen/trackpad gestures
if ! hyprpm list | grep -q "hyprgrass"; then
    info "Installing hyprgrass..."
    hyprpm add https://github.com/horriblename/hyprgrass || warn "Failed to add hyprgrass"
fi
hyprpm enable hyprgrass || warn "Failed to enable hyprgrass"

# hyprexpo+ - workspace overview (community fork, official plugin retired)
if ! hyprpm list | grep -q "hyprexpo"; then
    info "Installing hyprexpo+ (community fork)..."
    hyprpm add https://github.com/sandwichfarm/hyprexpo || warn "Failed to add hyprexpo"
fi
hyprpm enable hyprexpo || warn "Failed to enable hyprexpo"

hyprpm reload -n || warn "hyprpm reload failed, you may need to run 'hyprpm reload -n' manually after reboot"

# ----------------------------------------------------------------
# 7. Done
# ----------------------------------------------------------------
echo ""
info "=================================================="
info " Installation complete!"
info "=================================================="
echo ""
info "Your old configs (if any) were backed up to:"
echo "  $BACKUP_DIR"
echo ""
info "Next steps:"
echo "  1. Reboot or log out, then select Hyprland from your display manager."
echo "  2. Check for config errors with: hyprctl reload"
echo "  3. Open the keybind cheat sheet with: SUPER + H"
echo ""
warn "Note: If any package failed to install via apt (e.g. swww, hyprpicker),"
warn "you may need to install it manually from source. Hyprland itself will"
warn "still work, but some features (wallpapers, color picker) may not."
echo ""

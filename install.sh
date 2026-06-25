#!/bin/bash

# /* ---- 💫 https://github.com/Akashio28 💫 ---- */
# Akashio's Debian Hyprland Dotfiles v2 - Install Script (Lua config)

clear

OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"
INFO="$(tput setaf 4)[INFO]$(tput sgr0)"
WARN="$(tput setaf 1)[WARN]$(tput sgr0)"
CAT="$(tput setaf 6)[ACTION]$(tput sgr0)"
MAGENTA="$(tput setaf 5)"
YELLOW="$(tput setaf 3)"
GREEN="$(tput setaf 2)"
BLUE="$(tput setaf 4)"
SKY_BLUE="$(tput setaf 6)"
RESET="$(tput sgr0)"

printf "\n"
echo -e "\e[35m"
cat << "EOF"
    ___    __              __    _      ___   ____ 
   /   |  / /______ ______/ /_  (_)___ |__ \ ( __ )
  / /| | / //_/ __ `/ ___/ __ \/ / __ \__/ // __  |
 / ___ |/ ,< / /_/ (__  ) / / / / /_/ / __// /_/ / 
/_/  |_/_/|_|\__,_/____/_/ /_/_/\____/____/\____/  

  Debian Hyprland Dotfiles v2 (Lua)
  https://github.com/Akashio28/Debian_Hyprland_dotfilesv2
EOF
echo -e "\e[0m"
printf "\n"

if [[ $EUID -eq 0 ]]; then
    echo "${ERROR} Do NOT run as root!"
    exit 1
fi

if ! command -v apt &>/dev/null; then
    echo "${ERROR} Debian-based system required."
    exit 1
fi

echo "${NOTE} This script will:"
echo "  1. Update your system"
echo "  2. Install build dependencies for Hyprland"
echo "  3. Build & install Hyprland v0.55.4+ from source (Lua support)"
echo "  4. Install Wayland/app packages (waybar, rofi, etc.)"
echo "  5. Backup existing configs"
echo "  6. Copy dotfiles to ~/.config"
echo "  7. Setup hyprpm plugins"
printf "\n"
read -rp "${CAT} Continue? [y/N]: " confirm
case "$confirm" in
    [yY][eE][sS]|[yY]) echo "${OK} Starting..." ;;
    *) echo "${NOTE} Cancelled."; exit 0 ;;
esac

mkdir -p Install-Logs
LOG="Install-Logs/install-$(date +%d-%H%M%S).log"
echo "${INFO} Log: $LOG"
printf "\n"

echo "${INFO} Updating package lists..." | tee -a "$LOG"
sudo apt update 2>&1 | tee -a "$LOG"
echo "${OK} Package lists updated." | tee -a "$LOG"
printf "\n"

# ---- Build dependencies for Hyprland ----
echo "${INFO} Installing build dependencies..." | tee -a "$LOG"
BUILD_DEPS=(git meson cmake ninja-build g++ pkg-config
    libwayland-dev libxkbcommon-dev libcairo2-dev libpango1.0-dev
    libglib2.0-dev libdrm-dev libgbm-dev libinput-dev libudev-dev
    libxcb1-dev libxcb-dri3-dev libxcb-present-dev libxcb-composite0-dev
    libxcb-ewmh-dev libxcb-icccm4-dev libxcb-render-util0-dev
    libxcb-res0-dev libxcb-xinput-dev libxcb-xfixes0-dev libxcb-shape0-dev
    libxcb-randr0-dev libhyprutils-dev)

for pkg in "${BUILD_DEPS[@]}"; do
    if ! dpkg -l | grep -q "^ii.*$pkg"; then
        sudo apt install -y --no-install-recommends "$pkg" 2>&1 | tee -a "$LOG" || echo "${WARN} Failed: $pkg" | tee -a "$LOG"
    else
        echo "${OK} $pkg already installed." | tee -a "$LOG"
    fi
done
printf "\n"

# ---- Build & install Hyprland from source ----
echo "${INFO} Building Hyprland v0.55.4+ from source..." | tee -a "$LOG"
if [ ! -d "/tmp/Hyprland" ]; then
    git clone --recursive -b v0.55.4 https://github.com/hyprwm/Hyprland /tmp/Hyprland 2>&1 | tee -a "$LOG"
fi
cd /tmp/Hyprland
make all 2>&1 | tee -a "$LOG" && sudo make install 2>&1 | tee -a "$LOG"
echo "${OK} Hyprland built & installed." | tee -a "$LOG"
printf "\n"

# ---- Wayland/app packages ----
echo "${INFO} Installing Wayland/app packages..." | tee -a "$LOG"
PACKAGES=(hyprlock hypridle waybar rofi swaync kitty nautilus swww
    fonts-noto fonts-noto-color-emoji fonts-jetbrains-mono fonts-firacode
    wlogout wofi tofi btop cava fastfetch grim slurp swappy
    wl-clipboard cliphist brightnessctl pamixer playerctl pavucontrol
    network-manager nm-applet blueman polkit-kde-agent-1 jq imagemagick
    xdg-desktop-portal-hyprland xdg-utils qt5ct qt6ct nwg-look wallust
    python3-requests hyprsunset)

for pkg in "${PACKAGES[@]}"; do
    if ! dpkg -l | grep -q "^ii.*$pkg"; then
        sudo apt install -y --no-install-recommends "$pkg" 2>&1 | tee -a "$LOG" || echo "${WARN} Failed: $pkg" | tee -a "$LOG"
    else
        echo "${OK} $pkg already installed." | tee -a "$LOG"
    fi
done

printf "\n"
BACKUP_DIR="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"
CONFIG_DIRS=(hypr waybar rofi kitty swaync wlogout wofi tofi btop cava wallust nwg-look)

echo "${INFO} Backing up existing configs..." | tee -a "$LOG"
for dir in "${CONFIG_DIRS[@]}"; do
    if [ -d "$HOME/.config/$dir" ]; then
        mkdir -p "$BACKUP_DIR"
        mv "$HOME/.config/$dir" "$BACKUP_DIR/$dir"
        echo "${NOTE} Backed up $dir" | tee -a "$LOG"
    fi
done

printf "\n"
echo "${INFO} Copying dotfiles..." | tee -a "$LOG"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
for dir in "${CONFIG_DIRS[@]}"; do
    if [ -d "$SCRIPT_DIR/$dir" ]; then
        cp -r "$SCRIPT_DIR/$dir" "$HOME/.config/"
        echo "${OK} Copied $dir" | tee -a "$LOG"
    else
        echo "${WARN} $dir not found, skipping..." | tee -a "$LOG"
    fi
done

find "$HOME/.config/hypr" -name "*.sh" -exec chmod +x {} \;
echo "${OK} Scripts executable." | tee -a "$LOG"

printf "\n"
echo "${INFO} Setting up hyprpm..." | tee -a "$LOG"
if command -v hyprpm &>/dev/null; then
    hyprpm update 2>&1 | tee -a "$LOG"
    hyprpm reload -n 2>&1 | tee -a "$LOG"
    echo "${OK} hyprpm done." | tee -a "$LOG"
fi

printf "\n"
echo -e "${GREEN}"
cat << "EOF"
╔══════════════════════════════════════════╗
║   Installation Complete! 🎉              ║
║   1. Reboot your system                  ║
║   2. Select Hyprland at login            ║
║   3. Press SUPER + H for keybinds        ║
╚══════════════════════════════════════════╝
EOF
echo -e "${RESET}"

echo "${NOTE} Install log: $LOG"
printf "\n"

read -rp "${CAT} Reboot now? [y/N]: " rb
case "$rb" in
    [yY][eE][sS]|[yY]) sudo systemctl reboot ;;
    *) echo "${OK} Done! Reboot manually when ready." ;;
esac

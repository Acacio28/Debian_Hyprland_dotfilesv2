#!/bin/bash
# Auto-clone and install Akashio's Debian-Hyprland Dotfiles
# Usage: sh <(curl -L https://raw.githubusercontent.com/Acacio28/Debian_Hyprland_dotfilesv2/main/auto-install.sh)

OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"
INFO="$(tput setaf 4)[INFO]$(tput sgr0)"
YELLOW="$(tput setaf 3)"
RESET="$(tput sgr0)"

Distro="Debian_Hyprland_dotfilesv2"
Github_URL="https://github.com/Acacio28/$Distro.git"
Distro_DIR="$HOME/$Distro"

if ! command -v git &>/dev/null; then
    echo "${INFO} Installing git..."
    sudo apt install -y git || { echo "${ERROR} Failed to install git."; exit 1; }
fi

if [ -d "$Distro_DIR" ]; then
    echo "${NOTE} $Distro_DIR exists. Updating..."
    cd "$Distro_DIR"
    git stash 2>/dev/null || true
    git pull
else
    git clone --depth=1 "$Github_URL" "$Distro_DIR"
    cd "$Distro_DIR"
fi

chmod +x install.sh
./install.sh

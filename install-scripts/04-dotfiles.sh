#!/bin/bash
# Copy dotfiles to ~/.config and make scripts executable

LOG="Install-Logs/install-$(date +%d-%H%M%S).log"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BACKUP_DIR="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"
CONFIG_DIRS=(hypr waybar rofi kitty swaync wlogout wofi tofi btop cava wallust nwg-look)

for dir in "${CONFIG_DIRS[@]}"; do
    if [ -d "$HOME/.config/$dir" ]; then
        mkdir -p "$BACKUP_DIR"
        mv "$HOME/.config/$dir" "$BACKUP_DIR/$dir"
    fi
done

for dir in "${CONFIG_DIRS[@]}"; do
    if [ -d "$SCRIPT_DIR/$dir" ]; then
        cp -r "$SCRIPT_DIR/$dir" "$HOME/.config/"
    fi
done

find "$HOME/.config/hypr" -name "*.sh" -exec chmod +x {} \;

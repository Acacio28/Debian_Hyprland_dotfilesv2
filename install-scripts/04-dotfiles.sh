#!/bin/bash
# Copy dotfiles: sibling configs -> ~/.config, Hyprland config (repo root) -> ~/.config/hypr

mkdir -p Install-Logs
LOG="Install-Logs/install-$(date +%d-%H%M%S).log"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BACKUP_DIR="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"

# Sibling configs -> ~/.config/<dir>
CONFIG_DIRS=(waybar rofi kitty swaync wlogout wofi tofi btop cava wallust nwg-look)

# Hyprland config (repo root files/dirs) -> ~/.config/hypr/
HYPR_ITEMS=(
    hyprland.lua hyprland-gui.lua hyprland-gui.conf
    hypridle.conf hyprlock.conf hyprlock-1080p.conf
    monitors.conf monitors.lua workspaces.conf workspaces.lua
    application-style.conf initial-boot.sh
    UserConfigs UserScripts scripts animations configs Monitor_Profiles hyprmod
)

backup_config_dir() {
    if [ -d "$HOME/.config/$1" ]; then
        mkdir -p "$BACKUP_DIR"
        mv "$HOME/.config/$1" "$BACKUP_DIR/$1"
        echo "Backed up ~/.config/$1 -> $BACKUP_DIR/$1"
    fi
}

# Only back up a sibling config if we actually have a replacement for it
for dir in "${CONFIG_DIRS[@]}"; do
    if [ -d "$SCRIPT_DIR/$dir" ]; then
        backup_config_dir "$dir"
    fi
done

# Hyprland config: always backed up (HYPR_ITEMS below always exist in this repo)
backup_config_dir "hypr"

for dir in "${CONFIG_DIRS[@]}"; do
    if [ -d "$SCRIPT_DIR/$dir" ]; then
        cp -r "$SCRIPT_DIR/$dir" "$HOME/.config/"
    fi
done

mkdir -p "$HOME/.config/hypr"
for item in "${HYPR_ITEMS[@]}"; do
    if [ -e "$SCRIPT_DIR/$item" ]; then
        cp -r "$SCRIPT_DIR/$item" "$HOME/.config/hypr/"
    else
        echo "Note: $item not found in repo, skipping"
    fi
done

find "$HOME/.config/hypr" -name "*.sh" -exec chmod +x {} \;
echo "Dotfiles installed to ~/.config and ~/.config/hypr"
[ -d "$BACKUP_DIR" ] && echo "Previous configs backed up to $BACKUP_DIR"

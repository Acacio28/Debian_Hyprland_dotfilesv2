#!/bin/bash
# Uninstall Hyprland and restore backup
# USE WITH CAUTION

OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
WARN="$(tput setaf 1)[WARN]$(tput sgr0)"
CAT="$(tput setaf 6)[ACTION]$(tput sgr0)"
RESET="$(tput sgr0)"

echo "${WARN} This will remove Hyprland and all related configs!"
read -rp "${CAT} Continue? [y/N]: " confirm
case "$confirm" in
    [yY][eE][sS]|[yY]) ;;
    *) echo "Cancelled."; exit 0 ;;
esac

# Remove binaries
sudo rm -f /usr/local/bin/Hyprland /usr/local/bin/hyprctl /usr/local/bin/hyprpm
sudo rm -rf /usr/local/share/hyprland
sudo rm -rf /usr/local/include/hyprland
sudo rm -f /usr/local/lib/libhypr*

# Remove configs
read -rp "${CAT} Remove ~/.config/hypr configs? [y/N]: " rmconf
case "$rmconf" in
    [yY][eE][sS]|[yY]) rm -rf "$HOME/.config/hypr" "$HOME/.config/waybar" "$HOME/.config/rofi" "$HOME/.config/kitty" "$HOME/.config/swaync" ;;
    *) echo "Skipping config removal." ;;
esac

echo "${OK} Done. Reboot recommended."

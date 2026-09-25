#!/bin/bash
# Final verification

# Note: check command names, not package names (wl-clipboard ships wl-copy/wl-paste)
ESSENTIALS=(Hyprland waybar rofi kitty swaync swww wlogout btop fastfetch grim slurp wl-copy wallust)
MISSING=()

for cmd in "${ESSENTIALS[@]}"; do
    if ! command -v "$cmd" &>/dev/null && [ ! -f "/usr/local/bin/$cmd" ]; then
        MISSING+=("$cmd")
    fi
done

if [ ${#MISSING[@]} -gt 0 ]; then
    echo "Missing: ${MISSING[*]}"
else
    echo "All essential packages are installed."
fi

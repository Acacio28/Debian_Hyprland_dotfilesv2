#!/bin/bash
# Install Wayland/app packages

mkdir -p Install-Logs
LOG="Install-Logs/install-$(date +%d-%H%M%S).log"

CODENAME=""
if [ -r /etc/os-release ]; then
    . /etc/os-release
    [ "$ID" = "debian" ] && CODENAME="${VERSION_CODENAME:-}"
fi

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
    # exact name check - `dpkg -l | grep` also matches descriptions ("profiles" hits rofi)
    if ! dpkg -s "$pkg" 2>/dev/null | grep -q "Status: install ok installed"; then
        echo "Installing $pkg..."
        # PIPESTATUS (not the pipeline's rc) because `| tee` masks apt failures
        sudo apt install -y --no-install-recommends "$pkg" 2>&1 | tee -a "$LOG"
        APT_RC=${PIPESTATUS[0]}
        if [ "$APT_RC" -ne 0 ] && [ -n "$CODENAME" ]; then
            # After backports Hyprland, some deps (libxkbcommon0) only match from
            # backports - retry there before giving up (waybar case)
            sudo apt install -y --no-install-recommends -t "${CODENAME}-backports" "$pkg" 2>&1 | tee -a "$LOG"
            APT_RC=${PIPESTATUS[0]}
            [ "$APT_RC" -eq 0 ] && echo "$pkg installed from ${CODENAME}-backports"
        fi
        [ "$APT_RC" -ne 0 ] && echo "Warning: $pkg could not be installed (may not be in repo)"
    fi
done

# pywal from pip (wallust is a Rust crate, installed by 12-swww.sh)
if ! command -v wal &>/dev/null; then
    echo "Installing pywal via pip..."
    sudo pip3 install --break-system-packages pywal 2>&1 | tee -a "$LOG" || true
fi

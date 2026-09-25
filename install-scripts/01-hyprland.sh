#!/bin/bash
# Install Hyprland from Debian backports (0.55.x, native Lua config)

mkdir -p Install-Logs
LOG="Install-Logs/install-$(date +%d-%H%M%S).log"

if command -v Hyprland &>/dev/null || [ -f /usr/local/bin/Hyprland ]; then
    echo "Hyprland is already installed. Skipping."
    exit 0
fi

# Enable backports (not enabled by default on fresh Debian installs)
CODENAME=""
if [ -r /etc/os-release ]; then
    . /etc/os-release
    [ "$ID" = "debian" ] && CODENAME="${VERSION_CODENAME:-}"
fi

BACKPORTS_READY=""
if [ -n "$CODENAME" ]; then
    if ! grep -Rhsq "${CODENAME}-backports" /etc/apt/sources.list /etc/apt/sources.list.d/ 2>/dev/null; then
        echo "Enabling ${CODENAME}-backports..."
        echo "deb http://deb.debian.org/debian ${CODENAME}-backports main" | sudo tee /etc/apt/sources.list.d/backports.list >/dev/null
        sudo apt-get update 2>&1 | tee -a "$LOG"
    fi
    BACKPORTS_READY="-t ${CODENAME}-backports"
fi

# -t backports: hyprland needs libxkbcommon0 >= 1.12.3 which is only in backports;
# without it apt resolves deps against trixie/main and fails
sudo apt install -y $BACKPORTS_READY hyprland hyprland-dev 2>&1 | tee -a "$LOG"

if ! command -v Hyprland &>/dev/null; then
    echo "ERROR: Hyprland installation failed. Check $LOG"
    exit 1
fi
echo "Hyprland installed: $(Hyprland --version 2>/dev/null | head -1)"

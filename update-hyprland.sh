#!/bin/bash
# Update Hyprland to latest version
# Usage: ./update-hyprland.sh [--with-deps]

OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"
INFO="$(tput setaf 4)[INFO]$(tput sgr0)"
YELLOW="$(tput setaf 3)"
RESET="$(tput sgr0)"

LOG="update-$(date +%d-%H%M%S).log"

echo "${INFO} Updating Hyprland..." | tee -a "$LOG"

if [ ! -d "/tmp/Hyprland" ]; then
    git clone --recursive -b main https://github.com/Acacio28/Hyprland /tmp/Hyprland 2>&1 | tee -a "$LOG"
else
    cd /tmp/Hyprland
    git fetch origin 2>&1 | tee -a "$LOG"
    git checkout main 2>&1 | tee -a "$LOG"
    git submodule update --init --recursive 2>&1 | tee -a "$LOG"
fi

cd /tmp/Hyprland
make all 2>&1 | tee -a "$LOG" && sudo make install 2>&1 | tee -a "$LOG"

echo "${OK} Hyprland updated. Reboot recommended." | tee -a "$LOG"

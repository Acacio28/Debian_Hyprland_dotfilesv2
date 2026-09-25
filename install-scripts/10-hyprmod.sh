#!/bin/bash
# Install hyprmod Python GUI app

mkdir -p Install-Logs
LOG="Install-Logs/install-$(date +%d-%H%M%S).log"

if [ ! -d "/tmp/hyprmod/.git" ]; then
    rm -rf /tmp/hyprmod
    git clone https://github.com/Acacio28/hyprmod /tmp/hyprmod 2>&1 | tee -a "$LOG"
fi

if [ ! -d "/tmp/hyprmod/.git" ]; then
    echo "ERROR: could not clone https://github.com/Acacio28/hyprmod (repo missing or private?). Skipping HyprMod."
    exit 1
fi

cd /tmp/hyprmod || { echo "ERROR: /tmp/hyprmod not found."; exit 1; }
python3 -m venv .venv 2>&1 | tee -a "$LOG" || { echo "ERROR: failed to create venv."; exit 1; }
.venv/bin/pip install -e . 2>&1 | tee -a "$LOG" || { echo "ERROR: pip install failed."; exit 1; }
echo "HyprMod installed."

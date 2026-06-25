#!/bin/bash
# Install hyprmod Python GUI app

LOG="Install-Logs/install-$(date +%d-%H%M%S).log"

if [ ! -d "/tmp/hyprmod" ]; then
    git clone https://github.com/Acacio28/hyprmod /tmp/hyprmod 2>&1 | tee -a "$LOG" || true
fi

cd /tmp/hyprmod
python3 -m venv .venv 2>&1 | tee -a "$LOG"
.venv/bin/pip install -e . 2>&1 | tee -a "$LOG" || true

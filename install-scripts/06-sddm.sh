#!/bin/bash
# Install SDDM login manager

mkdir -p Install-Logs
LOG="Install-Logs/install-$(date +%d-%H%M%S).log"

sudo apt install -y --no-install-recommends sddm 2>&1 | tee -a "$LOG"
sudo systemctl enable sddm 2>&1 | tee -a "$LOG"

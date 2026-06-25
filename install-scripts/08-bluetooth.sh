#!/bin/bash
# Configure Bluetooth

LOG="Install-Logs/install-$(date +%d-%H%M%S).log"

sudo apt install -y bluez bluez-tools 2>&1 | tee -a "$LOG"
sudo systemctl enable bluetooth 2>&1 | tee -a "$LOG"
sudo systemctl start bluetooth 2>&1 | tee -a "$LOG"

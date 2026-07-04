#!/bin/bash
# Install GTK themes and icons

mkdir -p Install-Logs
LOG="Install-Logs/install-$(date +%d-%H%M%S).log"

sudo apt install -y papirus-icon-theme arc-theme 2>&1 | tee -a "$LOG"

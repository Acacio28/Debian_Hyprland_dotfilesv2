#!/bin/bash
# Install Thunar file manager

mkdir -p Install-Logs
LOG="Install-Logs/install-$(date +%d-%H%M%S).log"

sudo apt install -y --no-install-recommends thunar thunar-archive-plugin 2>&1 | tee -a "$LOG"

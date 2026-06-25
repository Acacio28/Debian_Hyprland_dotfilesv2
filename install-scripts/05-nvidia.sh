#!/bin/bash
# Configure NVIDIA GPU

LOG="Install-Logs/install-$(date +%d-%H%M%S).log"

if ! lspci | grep -i nvidia &>/dev/null; then
    echo "No NVIDIA GPU detected. Skipping."
    exit 0
fi

sudo apt install -y nvidia-dkms nvidia-utils nvidia-settings 2>&1 | tee -a "$LOG"

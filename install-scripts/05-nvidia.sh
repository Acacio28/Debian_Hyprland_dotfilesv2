#!/bin/bash
# Configure NVIDIA GPU

mkdir -p Install-Logs
LOG="Install-Logs/install-$(date +%d-%H%M%S).log"

if ! lspci | grep -i nvidia &>/dev/null; then
    echo "No NVIDIA GPU detected. Skipping."
    exit 0
fi

sudo apt install -y nvidia-dkms nvidia-utils nvidia-settings 2>&1 | tee -a "$LOG"

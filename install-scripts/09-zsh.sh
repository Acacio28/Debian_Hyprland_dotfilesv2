#!/bin/bash
# Install zsh with Oh-My-Zsh

LOG="Install-Logs/install-$(date +%d-%H%M%S).log"

sudo apt install -y zsh 2>&1 | tee -a "$LOG"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended 2>&1 | tee -a "$LOG"
fi

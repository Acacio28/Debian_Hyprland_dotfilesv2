#!/bin/bash
# Install swww - not packaged in Debian, build from source (needs rustc >= 1.89)

mkdir -p Install-Logs
LOG="Install-Logs/install-$(date +%d-%H%M%S).log"

if command -v swww &>/dev/null && command -v swww-daemon &>/dev/null; then
    echo "swww is already installed. Skipping."
    exit 0
fi

if ! command -v cargo &>/dev/null; then
    echo "Installing rustup toolchain (Debian rustc is too old for swww)..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --profile minimal 2>&1 | tee -a "$LOG"
fi
# shellcheck disable=SC1091
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

if ! command -v cargo &>/dev/null; then
    echo "ERROR: cargo unavailable, cannot build swww"
    exit 1
fi

echo "Building swww from source (takes a few minutes)..."
rm -rf /tmp/swww-build
git clone --depth 1 https://github.com/LGFae/swww /tmp/swww-build 2>&1 | tee -a "$LOG"
if [ ! -d /tmp/swww-build/.git ]; then
    echo "ERROR: could not clone https://github.com/LGFae/swww"
    exit 1
fi

(cd /tmp/swww-build && cargo build --release) 2>&1 | tee -a "$LOG"
if [ -f /tmp/swww-build/target/release/swww ] && [ -f /tmp/swww-build/target/release/swww-daemon ]; then
    sudo install -m755 /tmp/swww-build/target/release/swww /tmp/swww-build/target/release/swww-daemon /usr/local/bin/
    echo "swww installed: $(swww --version)"
else
    echo "ERROR: swww build failed. Check $LOG"
    exit 1
fi

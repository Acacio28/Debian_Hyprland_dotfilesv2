#!/bin/bash
# Install swww - not packaged in Debian, build from source (needs rustc >= 1.89)

mkdir -p Install-Logs
LOG="Install-Logs/install-$(date +%d-%H%M%S).log"

# Seed a default wallpaper so SUPER+F8 works right away on fresh installs
WP_DIR="$HOME/Pictures/wallpapers"
mkdir -p "$WP_DIR"
if ! find "$WP_DIR" -maxdepth 1 -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) 2>/dev/null | grep -q .; then
    if command -v convert &>/dev/null; then
        convert -size 1920x1080 gradient:'#1a1a2e'-'#e94560' "$WP_DIR/default.jpg" 2>/dev/null || true
    elif command -v magick &>/dev/null; then
        magick -size 1920x1080 gradient:'#1a1a2e'-'#e94560' "$WP_DIR/default.jpg" 2>/dev/null || true
    fi
    if [ -f "$WP_DIR/default.jpg" ]; then
        echo "Seeded default wallpaper: $WP_DIR/default.jpg"
    fi
fi

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

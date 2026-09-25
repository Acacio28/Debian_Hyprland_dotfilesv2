#!/bin/bash
# Install swww + wallust - neither is packaged in Debian; both built with cargo
# (wallust is a Rust crate: not on PyPI, not in apt)

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

NEED_CARGO=0
{ command -v swww &>/dev/null && command -v swww-daemon &>/dev/null; } || NEED_CARGO=1
command -v wallust &>/dev/null || NEED_CARGO=1

if [ "$NEED_CARGO" = "1" ]; then
    if ! command -v cargo &>/dev/null; then
        echo "Installing rustup toolchain (Debian rustc is too old for swww/wallust)..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --profile minimal 2>&1 | tee -a "$LOG"
    fi
    # shellcheck disable=SC1091
    [ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
    if ! command -v cargo &>/dev/null; then
        echo "ERROR: cargo unavailable, cannot build swww/wallust"
        exit 1
    fi
fi

EXIT_CODE=0

# --- wallust (crate name: wallust) ---
if ! command -v wallust &>/dev/null; then
    echo "Building wallust from crates.io (takes a few minutes)..."
    cargo install wallust --locked 2>&1 | tee -a "$LOG" || cargo install wallust 2>&1 | tee -a "$LOG"
    if [ -f "$HOME/.cargo/bin/wallust" ]; then
        sudo ln -sf "$HOME/.cargo/bin/wallust" /usr/local/bin/wallust
    fi
    if command -v wallust &>/dev/null; then
        echo "wallust installed: $(command -v wallust)"
    else
        echo "ERROR: wallust install failed. Check $LOG"
        EXIT_CODE=1
    fi
fi

# --- swww (github.com/LGFae/swww, needs rustc >= 1.89) ---
if ! command -v swww &>/dev/null || ! command -v swww-daemon &>/dev/null; then
    echo "Building swww from source (takes a few minutes)..."
    rm -rf /tmp/swww-build
    git clone --depth 1 https://github.com/LGFae/swww /tmp/swww-build 2>&1 | tee -a "$LOG"
    if [ ! -d /tmp/swww-build/.git ]; then
        echo "ERROR: could not clone https://github.com/LGFae/swww"
        EXIT_CODE=1
    else
        (cd /tmp/swww-build && cargo build --release) 2>&1 | tee -a "$LOG"
        if [ -f /tmp/swww-build/target/release/swww ] && [ -f /tmp/swww-build/target/release/swww-daemon ]; then
            sudo install -m755 /tmp/swww-build/target/release/swww /tmp/swww-build/target/release/swww-daemon /usr/local/bin/
            echo "swww installed: $(swww --version)"
        else
            echo "ERROR: swww build failed. Check $LOG"
            EXIT_CODE=1
        fi
    fi
fi

exit $EXIT_CODE

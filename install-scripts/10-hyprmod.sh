#!/bin/bash
# Install hyprmod (GTK settings GUI) permanently under ~/.local/share/hyprmod

mkdir -p Install-Logs
LOG="Install-Logs/install-$(date +%d-%H%M%S).log"

SRC_DIR="$HOME/.local/share/hyprmod/src"
VENV_DIR="$HOME/.local/share/hyprmod/.venv"

# GTK bindings from apt - compiling PyGObject from pip is slow and fragile
sudo apt install -y --no-install-recommends \
    python3-venv python3-gi python3-gi-cairo \
    gir1.2-gtk-4.0 gir1.2-adw-1 \
    libgirepository-2.0-dev libcairo2-dev \
    2>&1 | tee -a "$LOG"

if [ ! -d "$SRC_DIR/.git" ]; then
    mkdir -p "$HOME/.local/share/hyprmod"
    rm -rf "$SRC_DIR"
    git clone https://github.com/Acacio28/hyprmod "$SRC_DIR" 2>&1 | tee -a "$LOG"
fi

if [ ! -d "$SRC_DIR/.git" ]; then
    echo "ERROR: could not clone https://github.com/Acacio28/hyprmod"
    exit 1
fi

if [ ! -x "$VENV_DIR/bin/pip" ]; then
    python3 -m venv --system-site-packages "$VENV_DIR" 2>&1 | tee -a "$LOG" || {
        echo "ERROR: failed to create venv"; exit 1;
    }
fi

"$VENV_DIR/bin/pip" install --quiet "$SRC_DIR" 2>&1 | tee -a "$LOG" || {
    echo "ERROR: pip install hyprmod failed. Check $LOG"; exit 1;
}

mkdir -p "$HOME/.local/bin"
ln -sf "$VENV_DIR/bin/hyprmod" "$HOME/.local/bin/hyprmod"

# Register desktop entry + icon in ~/.local/share (no-op if already present)
# hicolor can be root-owned after earlier sudo runs - fix so icon install can mkdir
if [ -d "$HOME/.local/share/icons/hicolor" ] && ! [ -O "$HOME/.local/share/icons/hicolor" ]; then
    sudo chown "$USER:$USER" "$HOME/.local/share/icons/hicolor" 2>/dev/null || true
fi
"$VENV_DIR/bin/hyprmod" --install 2>&1 | tee -a "$LOG" || true

echo "HyprMod installed: $HOME/.local/bin/hyprmod"

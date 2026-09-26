#!/bin/bash
# Update Hyprland to latest version
# Builds from the local source tree so local patches are preserved
# (lua keyword fixes, compile fixes, logout/wl_list_remove fix).
# Usage: ./update-hyprland.sh [--fetch]
#   --fetch  fetch upstream and show pending commits (never touches local changes)

OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"
INFO="$(tput setaf 4)[INFO]$(tput sgr0)"

TREE="$HOME/landing-page/Hyprland"
UPSTREAM="https://github.com/hyprwm/Hyprland"
HYPRPM_CACHE="/var/cache/hyprpm/acacio"

LOG="update-$(date +%d-%H%M%S).log"

echo "${INFO} Updating Hyprland from $TREE ..." | tee -a "$LOG"

if [ ! -d "$TREE" ]; then
    echo "${NOTE} Local tree missing, cloning $UPSTREAM ..." | tee -a "$LOG"
    git clone --recursive "$UPSTREAM" "$TREE" 2>&1 | tee -a "$LOG" || {
        echo "${ERROR} clone failed" | tee -a "$LOG"; exit 1; }
elif [ "$1" = "--fetch" ]; then
    git -C "$TREE" fetch origin --tags 2>&1 | tee -a "$LOG"
    BEHIND=$(git -C "$TREE" rev-list --count HEAD..origin/main 2>/dev/null || echo "?")
    if [ "$BEHIND" != "0" ] && [ "$BEHIND" != "?" ]; then
        echo "${NOTE} origin/main has $BEHIND newer commits. NOT checked out" | tee -a "$LOG"
        echo "${NOTE} (working tree has local patches): update manually:" | tee -a "$LOG"
        echo "        git -C $TREE log --oneline HEAD..origin/main" | tee -a "$LOG"
    else
        echo "${OK} Already up to date with origin/main" | tee -a "$LOG"
    fi
fi

cd "$TREE" || exit 1

echo "${INFO} Building..." | tee -a "$LOG"
if ! make all 2>&1 | tee -a "$LOG"; then
    echo "${ERROR} Build failed" | tee -a "$LOG"; exit 1
fi

echo "${INFO} Installing..." | tee -a "$LOG"
if ! sudo make install 2>&1 | tee -a "$LOG"; then
    echo "${ERROR} Install failed" | tee -a "$LOG"; exit 1
fi
echo "${OK} Hyprland installed: $(/usr/local/bin/Hyprland --version 2>/dev/null | head -1)" | tee -a "$LOG"

# --- sync hyprpm (headers + state) with the new build -----------------------
ABI=$(/usr/local/bin/Hyprland --version-json 2>/dev/null | \
      python3 -c "import json,sys; print(json.load(sys.stdin)['abiHash'])" 2>/dev/null)

if [ -n "$ABI" ] && [ -d "$HYPRPM_CACHE/headersRoot" ]; then
    echo "${INFO} Refreshing hyprpm headers (abi: $ABI)..." | tee -a "$LOG"

    if ! sudo make PREFIX="$HYPRPM_CACHE/headersRoot" installheaders 2>&1 | tee -a "$LOG"; then
        echo "${ERROR} installheaders failed (plugins wont rebuild)" | tee -a "$LOG"
    fi

    # hyprland.pc ships with a wrong prefix, point it at headersRoot
    PC="$HYPRPM_CACHE/headersRoot/share/pkgconfig/hyprland.pc"
    if [ -f "$PC" ]; then
        sudo sed -i "s|^prefix=.*|prefix=$HYPRPM_CACHE/headersRoot/include|" "$PC"
    fi

    # state hash must equal the running/installed abiHash
    STATE="$HYPRPM_CACHE/state.toml"
    OLD=$(grep -oP "^hash = '\K[^']+" "$STATE" 2>/dev/null)
    if [ "$OLD" != "$ABI" ]; then
        echo "${NOTE} hyprpm state hash updated: ${OLD:-<empty>} -> $ABI" | tee -a "$LOG"
        echo "[state]
dont_warn_install = true
hash = '$ABI'" | sudo tee "$STATE" > /dev/null
    fi

    # hyprpm loads plugins as the user, keep headers world-readable
    sudo find "$HYPRPM_CACHE/headersRoot" -type d -exec chmod 755 {} +
    sudo find "$HYPRPM_CACHE/headersRoot" -type f -exec chmod 644 {} +

    echo "${OK} hyprpm headers/state refreshed" | tee -a "$LOG"
fi

echo "${NOTE} Log out and back in to run the new binary." | tee -a "$LOG"
echo "${NOTE} After relogin, load plugins with:  hyprpm reload" | tee -a "$LOG"
echo "${NOTE} If a plugin fails with 'Version mismatch', rebuild it" | tee -a "$LOG"
echo "${NOTE} against the fresh headers:  hyprpm update -f" | tee -a "$LOG"
echo "${OK} Hyprland updated." | tee -a "$LOG"

#!/bin/bash
# Setup hyprpm and install plugins
# hyprpm add needs a LIVE Hyprland instance (queries version over IPC), so on
# fresh installs (pre-login) we drop a helper that auto-runs at session start.

mkdir -p Install-Logs
LOG="Install-Logs/install-$(date +%d-%H%M%S).log"

if ! command -v hyprpm &>/dev/null; then
    echo "hyprpm not found. Ensure Hyprland is installed first."
    exit 1
fi

# Source of truth for plugin install; run now if a session is up, otherwise at first login
HELPER="$HOME/.local/bin/hyprpm-plugins-setup.sh"
mkdir -p "$HOME/.local/bin"
cat > "$HELPER" <<'EOF'
#!/bin/bash
# Auto-run from Startup_Apps.lua; installs hyprpm plugins once a session exists.
command -v hyprpm >/dev/null 2>&1 || exit 0
hyprctl version >/dev/null 2>&1 || exit 0
if hyprpm list 2>/dev/null | grep -q hyprgrass && hyprpm list 2>/dev/null | grep -q hyprexpo; then
    exit 0
fi
hyprpm update 2>&1 || true
hyprpm add https://github.com/horriblename/hyprgrass 2>&1 || true
hyprpm add https://github.com/sandwichfarm/hyprexpo 2>&1 || true
hyprpm add https://github.com/hyprwm/hyprland-plugins 2>&1 || true
hyprpm enable hyprgrass 2>&1 || true
hyprpm enable hyprexpo 2>&1 || true
hyprpm reload -n 2>&1 || true
exit 0
EOF
chmod +x "$HELPER"

if hyprctl version &>/dev/null; then
    "$HELPER" 2>&1 | tee -a "$LOG"
else
    echo "Hyprland not running - plugins will auto-install on first login ($HELPER)"
fi
exit 0

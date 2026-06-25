#!/bin/bash
# Akashio's Debian Hyprland Dotfiles v2 - Install Script (Lua config)
# https://github.com/Acacio28/Debian_Hyprland_dotfilesv2

clear

OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"
INFO="$(tput setaf 4)[INFO]$(tput sgr0)"
WARN="$(tput setaf 1)[WARN]$(tput sgr0)"
CAT="$(tput setaf 6)[ACTION]$(tput sgr0)"
MAGENTA="$(tput setaf 5)"
YELLOW="$(tput setaf 3)"
GREEN="$(tput setaf 2)"
BLUE="$(tput setaf 4)"
SKY_BLUE="$(tput setaf 6)"
RESET="$(tput sgr0)"

printf "\n"
echo -e "\e[35m"
cat << "EOF"
    ___    __              __    _      ___   ____
   /   |  / /______ ______/ /_  (_)___ |__ \ ( __ )
  / /| | / //_/ __ `/ ___/ __ \/ / __ \__/ // __  |
 / ___ |/ ,< / /_/ (__  ) / / / / /_/ / __// /_/ /
/_/  |_/_/|_|\__,_/____/_/ /_/_/\____/____/\____/

  Debian Hyprland Dotfiles v2 (Lua)
  https://github.com/Acacio28/Debian_Hyprland_dotfilesv2
EOF
echo -e "\e[0m"
printf "\n"

print_help() {
    cat <<EOF
Usage: ${0##*/} [OPTIONS]

Options:
  --preset <file>       Load preset file with options
  --tty                 Use simple TTY prompts instead of whiptail
  -h, --help            Show this help and exit
EOF
}

# --- APT source checks ---
_detect_codename() {
    local c
    if [ -r /etc/os-release ]; then
        . /etc/os-release 2>/dev/null || true
        c="${DEBIAN_CODENAME:-${VERSION_CODENAME:-}}"
    fi
    [ -z "$c" ] && c=$(lsb_release -c -s 2>/dev/null || echo "trixie")
    echo "$c"
}

_has_deb_src_enabled() {
    sudo grep -RhsE '^[[:space:]]*deb-src[[:space:]]' /etc/apt/sources.list /etc/apt/sources.list.d/*.list 2>/dev/null | grep -q .
}

_enable_deb_src() {
    for f in /etc/apt/sources.list /etc/apt/sources.list.d/*.list; do
        [ -f "$f" ] || continue
        sudo sed -i -E 's/^[[:space:]]*#([[:space:]]*deb-src[[:space:]])/\1/' "$f" 2>/dev/null || true
    done
}

verify_apt_sources() {
    _enable_deb_src
    echo "${INFO} APT sources: deb-src: $(_has_deb_src_enabled && echo "${GREEN}ENABLED${RESET}" || echo "${YELLOW}MISSING${RESET}")"
}

# --- CLI parsing ---
TTY_MODE=0
PRESET_FILE=""
args=("$@")
for ((i=0; i<${#args[@]}; i++)); do
    case "${args[$i]}" in
        --tty) TTY_MODE=1 ;;
        -h|--help) print_help; exit 0 ;;
        --preset) [ $((i+1)) -lt ${#args[@]} ] && PRESET_FILE="${args[$((i+1))]}" ;;
    esac
done

# --- Root check ---
if [[ $EUID -eq 0 ]]; then
    echo "${ERROR} Do NOT run as root!"
    exit 1
fi

if ! command -v apt &>/dev/null; then
    echo "${ERROR} Debian-based system required."
    exit 1
fi

# --- Welcome ---
echo "${NOTE} This script will:"
echo "  1. Install build dependencies & build Hyprland from source"
echo "  2. Install Wayland/app packages (waybar, rofi, etc.)"
echo "  3. Setup hyprpm plugins (hyprgrass, hyprexpo)"
echo "  4. Backup existing configs & copy dotfiles"
echo "  5. Optional: NVIDIA, SDDM, GTK themes, Bluetooth, Zsh"
printf "\n"
read -rp "${CAT} Continue? [y/N]: " confirm
case "$confirm" in
    [yY][eE][sS]|[yY]) echo "${OK} Starting..." ;;
    *) echo "${NOTE} Cancelled."; exit 0 ;;
esac

mkdir -p Install-Logs
LOG="Install-Logs/install-$(date +%d-%H%M%S).log"
echo "${INFO} Log: $LOG"
printf "\n"

# --- Install whiptail for UI ---
if [ "$TTY_MODE" -ne 1 ] && ! command -v whiptail >/dev/null; then
    sudo apt install -y whiptail 2>&1 | tee -a "$LOG"
fi

# --- Verify APT sources ---
verify_apt_sources

# --- System update ---
echo "${INFO} Updating package lists..." | tee -a "$LOG"
sudo apt update 2>&1 | tee -a "$LOG"

# --- Preset handling ---
gtk_themes="OFF"
bluetooth="OFF"
sddm="OFF"
sddm_theme="OFF"
zsh="OFF"
dots="ON"
nvidia="OFF"
input_group="OFF"
thunar="OFF"
hyprmod="OFF"

load_preset() {
    if [ -f "$1" ]; then
        source "$1"
    fi
}

[ -n "${PRESET_FILE:-}" ] && load_preset "$PRESET_FILE"

# --- Option selection ---
nvidia_detected=false
lspci | grep -i nvidia &>/dev/null && nvidia_detected=true

input_group_detected=false
groups "$(whoami)" | grep -q '\binput\b' || input_group_detected=true

if [ "$TTY_MODE" -eq 1 ]; then
    echo "=== Select options ==="
    [ "$nvidia_detected" == "true" ] && read -rp "Configure NVIDIA? [y/N]: " n && [ "$n" = "y" ] && nvidia="ON"
    read -rp "Install GTK themes? [Y/n]: " g && [ "$g" != "n" ] && gtk_themes="ON"
    read -rp "Configure Bluetooth? [y/N]: " b && [ "$b" = "y" ] && bluetooth="ON"
    read -rp "Install SDDM login manager? [y/N]: " s && [ "$s" = "y" ] && sddm="ON"
    read -rp "Install Zsh + Oh-My-Zsh? [y/N]: " z && [ "$z" = "y" ] && zsh="ON"
    read -rp "Install HyprMod GUI app? [y/N]: " h && [ "$h" = "y" ] && hyprmod="ON"
else
    options_cmd=(
        whiptail --title "Select Options" --checklist "Choose options to install" 28 75 20
    )

    [ "$nvidia_detected" == "true" ] && options_cmd+=("nvidia" "Configure NVIDIA GPU" "OFF")
    [ "$input_group_detected" == "true" ] && options_cmd+=("input_group" "Add user to input group" "OFF")
    options_cmd+=(
        "gtk_themes" "Install GTK themes" "ON"
        "bluetooth" "Configure Bluetooth" "OFF"
        "thunar" "Install Thunar file manager" "OFF"
        "sddm" "Install SDDM login manager" "OFF"
        "zsh" "Install Zsh + Oh-My-Zsh" "OFF"
        "hyprmod" "Install HyprMod GUI app" "OFF"
    )

    selected_options=$("${options_cmd[@]}" 3>&1 1>&2 2>&3) || exit 1
    selected_options=$(echo "$selected_options" | tr -d '"')
    for opt in $selected_options; do
        case "$opt" in
            nvidia) nvidia="ON" ;;
            input_group) input_group="ON" ;;
            gtk_themes) gtk_themes="ON" ;;
            bluetooth) bluetooth="ON" ;;
            thunar) thunar="ON" ;;
            sddm) sddm="ON" ;;
            zsh) zsh="ON" ;;
            hyprmod) hyprmod="ON" ;;
        esac
    done
fi

# --- Execute install scripts ---
script_dir=install-scripts

run_script() {
    local script="$1"
    local path="$script_dir/$script"
    if [ -f "$path" ]; then
        chmod +x "$path"
        "$path" 2>&1 | tee -a "$LOG"
    else
        echo "${WARN} $script not found" | tee -a "$LOG"
    fi
}

# 1. Build dependencies
echo "${INFO} Installing build dependencies..." | tee -a "$LOG"
run_script "00-dependencies.sh"

# 2. Build Hyprland
echo "${INFO} Building Hyprland from source..." | tee -a "$LOG"
run_script "01-hyprland.sh"

# 3. System packages
echo "${INFO} Installing system packages..." | tee -a "$LOG"
run_script "03-packages.sh"

# 4. Dotfiles
echo "${INFO} Backing up and copying dotfiles..." | tee -a "$LOG"
run_script "04-dotfiles.sh"

# 5. Plugins
echo "${INFO} Setting up hyprpm plugins..." | tee -a "$LOG"
run_script "02-plugins.sh"

# Optional components
[ "$nvidia" = "ON" ] && run_script "05-nvidia.sh"
[ "$sddm" = "ON" ] && run_script "06-sddm.sh"
[ "$gtk_themes" = "ON" ] && run_script "07-gtk-themes.sh"
[ "$bluetooth" = "ON" ] && run_script "08-bluetooth.sh"
[ "$zsh" = "ON" ] && run_script "09-zsh.sh"
[ "$hyprmod" = "ON" ] && run_script "10-hyprmod.sh"

# Final check
run_script "99-final-check.sh"

# --- Cleanup ---
rm -f JetBrainsMono.tar.xz VictorMonoAll.zip FantasqueSansMono.zip 2>/dev/null || true

# --- Done ---
printf "\n%.0s" {1..2}
if command -v Hyprland &>/dev/null || [ -f /usr/local/bin/Hyprland ]; then
    echo "${GREEN}Installation complete!" | tee -a "$LOG"
    echo "${NOTE} 1. Reboot your system" | tee -a "$LOG"
    echo "${NOTE} 2. Select Hyprland at login" | tee -a "$LOG"
    echo "${NOTE} 3. Press SUPER + H for keybinds" | tee -a "$LOG"
    printf "\n"
    read -rp "${CAT} Reboot now? [y/N]: " rb
    case "$rb" in
        [yY][eE][sS]|[yY]) sudo systemctl reboot ;;
        *) echo "${OK} Done! Reboot manually when ready." ;;
    esac
else
    echo "${ERROR} Hyprland was NOT installed. Check the logs." | tee -a "$LOG"
fi

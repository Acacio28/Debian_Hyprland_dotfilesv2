# /* ---- 💫 https://github.com/Acacio28 💫 ---- */
#!/bin/bash
# 💫 Antigravity Waybar Theme Switcher 💫

THEMES_DIR="$HOME/.config/waybar/themes"
WAYBAR_CONFIG="$HOME/.config/waybar/config.jsonc"
WAYBAR_STYLE="$HOME/.config/waybar/style.css"
REFRESH_SCRIPT="$HOME/.config/hypr/scripts/Refresh.sh"
ROFI_CONFIG="$HOME/.config/rofi/config-waybar-style.rasi"

# Pastikan folder themes ada
if [ ! -d "$THEMES_DIR" ]; then
    echo "Folder themes tidak ditemukan!"
    exit 1
fi

# Jika argumen pertama diberikan, gunakan langsung sebagai nama tema
if [ -n "$1" ]; then
    choice="$1"
else
    # Cari tema aktif saat ini
    if [ -L "$WAYBAR_CONFIG" ]; then
        current_target=$(readlink -f "$WAYBAR_CONFIG")
        current_theme=$(basename "$(dirname "$current_target")")
    else
        current_theme="standar"
    fi

    # Ambil semua daftar tema
    mapfile -t themes < <(find "$THEMES_DIR" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | sort)

    # Cari baris yang aktif untuk Rofi / CLI
    default_row=0
    MARKER="👉"
    for i in "${!themes[@]}"; do
        if [[ "${themes[i]}" == "$current_theme" ]]; then
            themes[i]="$MARKER ${themes[i]}"
            default_row=$i
        fi
    done

    # Cek ketersediaan Rofi dan layar grafis
    if [ -n "$WAYLAND_DISPLAY" ] || [ -n "$DISPLAY" ] && command -v rofi >/dev/null 2>&1; then
        # Tutup Rofi jika sudah berjalan
        pkill rofi 2>/dev/null
        
        choice=$(printf '%s\n' "${themes[@]}" \
            | rofi -i -dmenu \
                   -config "$ROFI_CONFIG" \
                   -p "Pilih Tema" \
                   -selected-row "$default_row"
        )
    else
        # Fallback CLI jika dipanggil dari terminal murni
        echo -e "\033[1;36m=== PILIH TEMA WAYBAR ===\033[0m"
        for i in "${!themes[@]}"; do
            echo -e " [$i] ${themes[i]}"
        done
        read -r -p "Masukkan nomor tema pilihan Anda: " choice_idx
        if [[ "$choice_idx" =~ ^[0-9]+$ ]] && [ "$choice_idx" -lt "${#themes[@]}" ]; then
            choice="${themes[$choice_idx]}"
        else
            echo "Pilihan tidak valid."
            exit 1
        fi
    fi
fi

# Jika tidak ada pilihan, keluar
[[ -z "$choice" ]] && { echo "Tidak ada tema yang dipilih. Keluar."; exit 0; }

# Bersihkan marker
choice=${choice#$MARKER }
choice=$(echo "$choice" | xargs) # trim whitespace

# Cek apakah folder tema yang dipilih valid
TARGET_THEME_DIR="$THEMES_DIR/$choice"
if [ ! -d "$TARGET_THEME_DIR" ]; then
    echo "Error: Tema '$choice' tidak ditemukan."
    echo "Pilihan tema yang tersedia:"
    find "$THEMES_DIR" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | sort | sed 's/^/ - /'
    exit 1
fi

# Terapkan tema dengan symlink
echo "Menerapkan tema: $choice"
rm -f "$WAYBAR_CONFIG"
rm -f "$WAYBAR_STYLE"

ln -sf "$TARGET_THEME_DIR/config.jsonc" "$WAYBAR_CONFIG"
ln -sf "$TARGET_THEME_DIR/style.css" "$WAYBAR_STYLE"

# Segarkan Waybar
if [ -f "$REFRESH_SCRIPT" ]; then
    echo "Menyegarkan Waybar..."
    "$REFRESH_SCRIPT" &
else
    pkill -f waybar
    sleep 1
    waybar &
    notify-send "Waybar Switcher" "Tema $choice berhasil diterapkan."
fi

exit 0

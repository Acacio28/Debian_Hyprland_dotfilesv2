# Debian Hyprland Dotfiles v2

Konfigurasi Hyprland pribadi, berbasis [JaKooLit Hyprland-Dots](https://github.com/JaKooLit), yang dimodifikasi dan disesuaikan untuk **Hyprland v0.55.2** di Debian.

---

## 📋 Spesifikasi

- **Compositor**: Hyprland `v0.55.2`
- **Distro**: Debian
- **Config base**: JaKooLit dotfiles
- **Config language**: Hyprlang (`.conf`)

---

## 📁 Struktur Folder

```
~/.config/hypr/
├── hyprland.conf          # Entry point, source semua config lain
├── hyprland-gui.conf       # Settings dari HyprMod (GUI tool)
├── monitors.conf           # Konfigurasi monitor (nwg-displays)
├── workspaces.conf         # Aturan workspace
├── hypridle.conf            # Idle daemon config
├── hyprlock.conf            # Lockscreen config
│
├── configs/
│   └── Keybinds.conf        # Keybind default dari JaKooLit (jangan banyak diubah)
│
├── UserConfigs/             # ⭐ Tempat utama kustomisasi
│   ├── UserKeybinds.conf     # Keybind custom milik sendiri
│   ├── UserSettings.conf     # Settings utama (dwindle, decoration, plugin, dll)
│   ├── UserAnimations.conf
│   ├── UserDecorations.conf
│   ├── WindowRules.conf
│   ├── Laptops.conf / LaptopDisplay.conf
│   ├── Startup_Apps.conf     # exec-once untuk aplikasi startup
│   └── ENVariables.conf      # Environment variables
│
├── animations/              # Kumpulan preset animasi (ML4W, HyDE, dll)
├── scripts/                 # Script bash untuk fitur tambahan (rofi, screenshot, dll)
├── UserScripts/             # Script custom tambahan
├── wallpaper_effects/        # Cache wallpaper effect
└── wallust/                  # Theme/colorscheme generator output
```

---

## 🔌 Plugin (via hyprpm)

| Plugin | Repo | Fungsi |
|---|---|---|
| `hyprgrass` | [horriblename/hyprgrass](https://github.com/horriblename/hyprgrass) | Touchscreen/trackpad gestures (swipe ganti workspace) |
| `hyprexpo` (fork) | [sandwichfarm/hyprexpo](https://github.com/sandwichfarm/hyprexpo) | Workspace overview (expo) — fork community karena plugin official sudah retired sejak Hyprland 0.55 |

### Install plugin
```bash
hyprpm add https://github.com/horriblename/hyprgrass
hyprpm add https://github.com/sandwichfarm/hyprexpo
hyprpm enable hyprgrass
hyprpm enable hyprexpo
hyprpm reload -n
```

### Update plugin (setelah update Hyprland)
```bash
hyprpm update
hyprpm reload -n
```

---

## ⌨️ Keybinds Penting

> Default keybind lengkap ada di `configs/Keybinds.conf`, custom keybind di `UserConfigs/UserKeybinds.conf`.

| Keybind | Aksi |
|---|---|
| `SUPER + Return` | Buka terminal |
| `SUPER + D` | App launcher (rofi) |
| `SUPER + E` | File manager |
| `SUPER + Q` | Tutup window aktif |
| `SUPER + W` | Pilih wallpaper |
| `SUPER + R` | Wallpaper random |
| `SUPER + A` | Workspace overview (hyprexpo+) |
| `SUPER + SHIFT + I` | Toggle split (dwindle) |
| `SUPER + SPACE` | Toggle floating |
| `SUPER + SHIFT + F` | Fullscreen |
| `SUPER + N` | Toggle night light (hyprsunset) |
| `SUPER + H` | Cheat sheet keybinds |
| `Swipe 3 jari` | Ganti workspace (hyprgrass) |

---

## ⚙️ Catatan Migrasi ke Hyprland 0.55.2

Beberapa breaking change yang sudah diperbaiki di config ini:

1. **`togglesplit` dispatcher dihapus** sejak 0.54 → diganti `layoutmsg, togglesplit`
   ```
   bind = $mainMod SHIFT, I, layoutmsg, togglesplit
   ```

2. **`dwindle:pseudotile`** dihapus di 0.55 (tidak berfungsi apa-apa) → dihapus dari `UserSettings.conf`

3. **`misc:vfr`** dipindah ke `debug:` (bukan untuk production) → dihapus dari `UserSettings.conf`

4. **`hyprexpo` official plugin** sudah *retired* dari `hyprwm/hyprland-plugins` → diganti dengan fork [`sandwichfarm/hyprexpo`](https://github.com/sandwichfarm/hyprexpo) ("hyprexpo+") yang masih maintained dan mendukung keyboard navigation + label workspace.

---

## 🚀 Instalasi (di mesin baru)

```bash
git clone https://github.com/Akashio28/Debian_Hyprland_dotfilesv2.git ~/.config/hypr

cd ~/.config/hypr
hyprpm add https://github.com/horriblename/hyprgrass
hyprpm add https://github.com/sandwichfarm/hyprexpo
hyprpm enable hyprgrass
hyprpm enable hyprexpo

hyprctl reload
```

---

## 📝 TODO / Catatan

- [ ] Pertimbangkan migrasi config ke Lua (opsional, hyprlang masih didukung untuk beberapa rilis ke depan)
- [ ] Bersihkan file backup (`*.bak`, `*-old.conf`) yang sudah tidak terpakai

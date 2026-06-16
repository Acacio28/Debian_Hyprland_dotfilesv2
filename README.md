<div align="center">

# 🌙 Akashio's Debian-Hyprland Dotfiles 🐧

#### For Debian 13 (Trixie) and above — Hyprland v0.55.2

<p align="center">
  <img src="screenshots/01-desktop-night.png" width="600" />
</p>

![GitHub Repo stars](https://img.shields.io/github/stars/Akashio28/Debian_Hyprland_dotfilesv2?style=for-the-badge&color=cba6f7) ![GitHub last commit](https://img.shields.io/github/last-commit/Akashio28/Debian_Hyprland_dotfilesv2?style=for-the-badge&color=b4befe) ![GitHub repo size](https://img.shields.io/github/repo-size/Akashio28/Debian_Hyprland_dotfilesv2?style=for-the-badge&color=cba6f7)

<br/>
</div>

## IMPORTANT note for Hyprland 0.55.x users

> If you are coming from an older Hyprland version (0.49–0.54), some keybinds and settings in this config have changed.
> See [`CHANGELOG.md`](CHANGELOG.md) for the full list of breaking changes already patched in this config.
> Run `./install.sh` again after pulling updates — it is safe to re-run.

<div align="center">
<br>
  <a href="#-prerequisites"><kbd> <br> Read this First <br> </kbd></a>&ensp;&ensp;
  <a href="#-quick-install"><kbd> <br> Installation <br> </kbd></a>&ensp;&ensp;
  <a href="#%EF%B8%8F-gallery"><kbd> <br> Gallery <br> </kbd></a>&ensp;&ensp;
  <a href="#%EF%B8%8F-key-keybinds"><kbd> <br> Keybinds <br> </kbd></a>&ensp;&ensp;
 </div><br>

<p align="center">
  <img src="screenshots/02-desktop-sunset.png" width="500" />
</p>

---

## 📋 Specs

- **Compositor**: Hyprland `v0.55.2`
- **Distro**: Debian (apt-based, Debian 13 "Trixie" or later recommended)
- **Config base**: [JaKooLit Hyprland-Dots](https://github.com/JaKooLit), modified & adapted by [@Akashio28](https://github.com/Akashio28)
- **Config language**: Hyprlang (`.conf`)
- **Plugins**: `hyprgrass`, `hyprexpo+` (via `hyprpm`)

---

### 🪧🪧🪧 ANNOUNCEMENT 🪧🪧🪧

[Full Changelog](CHANGELOG.md)

- **2026** — Migrated config to Hyprland `v0.55.2`
    - Fixed `togglesplit` dispatcher (now `layoutmsg, togglesplit`)
    - Removed deprecated `dwindle:pseudotile` and `misc:vfr`
    - Replaced retired official `hyprexpo` plugin with the community fork [`sandwichfarm/hyprexpo`](https://github.com/sandwichfarm/hyprexpo) ("hyprexpo+")

---

#### ⚠️ Prerequisites and VERY Important

- Do **not** run `install.sh` with `sudo` or as `root`
- This installer requires a user with `sudo` privileges to install packages
- Debian 13 "Trixie" or greater (apt-based systems only)
- `git` must be installed: `sudo apt install -y git`

> [!IMPORTANT]
> Install a backup tool like `timeshift` or `snapper` and back up your system before running this script (**HIGHLY RECOMMENDED**).

> [!CAUTION]
> Clone this script into a directory where you have write permissions, e.g. your `HOME` directory or anywhere within it.

---

## 🖼️ Gallery

<div align="center">

| Desktop (Night wallpaper) | Desktop (Sunset wallpaper) |
| :---: | :---: |
| ![Desktop Night](screenshots/01-desktop-night.png) | ![Desktop Sunset](screenshots/02-desktop-sunset.png) |

| Rofi App Launcher | wlogout Power Menu |
| :---: | :---: |
| ![Rofi Launcher](screenshots/03-rofi-launcher.png) | ![wlogout](screenshots/04-wlogout.png) |

</div>

---

## ✨ Features

- Ready-to-use Hyprland config adapted for v0.55.2 (breaking changes already patched)
- Waybar, Rofi, SwayNC, Kitty, and wlogout pre-configured
- Wallpaper management via `swww` + `wallust` color theming
- Touchscreen/trackpad gesture support (`hyprgrass`)
- Workspace overview via `hyprexpo+` (community-maintained fork)
- Automatic config backup before installing — no overwriting your old setup blindly

---

## 📁 Folder Structure

```
~/.config/hypr/
├── hyprland.conf          # Entry point, sources all other configs
├── hyprland-gui.conf       # Settings from HyprMod (GUI tool)
├── monitors.conf           # Monitor configuration (nwg-displays)
├── workspaces.conf         # Workspace rules
├── hypridle.conf            # Idle daemon config
├── hyprlock.conf            # Lockscreen config
│
├── configs/
│   └── Keybinds.conf        # JaKooLit default keybinds (avoid heavy edits)
│
├── UserConfigs/             # ⭐ Main place for customization
│   ├── UserKeybinds.conf     # Personal custom keybinds
│   ├── UserSettings.conf     # Core settings (dwindle, decoration, plugins, etc.)
│   ├── UserAnimations.conf
│   ├── UserDecorations.conf
│   ├── WindowRules.conf
│   ├── Laptops.conf / LaptopDisplay.conf
│   ├── Startup_Apps.conf     # exec-once for startup applications
│   └── ENVariables.conf      # Environment variables
│
├── animations/              # Animation presets (ML4W, HyDE, etc.)
├── scripts/                 # Bash scripts for extra features (rofi, screenshot, etc.)
├── UserScripts/             # Additional custom scripts
├── wallpaper_effects/        # Wallpaper effect cache
└── wallust/                  # Theme/colorscheme generator output
```

---

## 🔌 Plugins (via hyprpm)

| Plugin            | Repo                                                                 | Purpose                                                                                                |
| ----------------- | --------------------------------------------------------------------| ---------------------------------------------------------------------------------------------------- |
| `hyprgrass`       | [horriblename/hyprgrass](https://github.com/horriblename/hyprgrass) | Touchscreen/trackpad gestures (swipe to switch workspaces)                                            |
| `hyprexpo` (fork) | [sandwichfarm/hyprexpo](https://github.com/sandwichfarm/hyprexpo)   | Workspace overview (expo) — community fork, since the official plugin was retired as of Hyprland 0.55 |

### Install plugins manually

```bash
hyprpm add https://github.com/horriblename/hyprgrass
hyprpm add https://github.com/sandwichfarm/hyprexpo
hyprpm enable hyprgrass
hyprpm enable hyprexpo
hyprpm reload -n
```

### Update plugins (after a Hyprland update)

```bash
hyprpm update
hyprpm reload -n
```

---

## ⌨️ Key Keybinds

> Full default keybinds are in `configs/Keybinds.conf`, custom keybinds are in `UserConfigs/UserKeybinds.conf`.

> [!TIP]
> Open the in-app keybind cheat sheet anytime with `SUPER + H`.

| Keybind             | Action                          |
| ------------------- | -------------------------------- |
| `SUPER + Return`    | Open terminal                    |
| `SUPER + D`         | App launcher (rofi)              |
| `SUPER + E`         | File manager                     |
| `SUPER + Q`         | Close active window               |
| `SUPER + W`         | Select wallpaper                  |
| `SUPER + R`         | Random wallpaper                  |
| `SUPER + A`         | Workspace overview (hyprexpo+)    |
| `SUPER + SHIFT + I` | Toggle split (dwindle)            |
| `SUPER + SPACE`     | Toggle floating                   |
| `SUPER + SHIFT + F` | Fullscreen                        |
| `SUPER + N`         | Toggle night light (hyprsunset)   |
| `SUPER + H`         | Keybind cheat sheet               |
| `3-finger swipe`    | Switch workspace (hyprgrass)      |

---

## ✨ Quick Install

> [!CAUTION]
> Do **NOT** run the install script as `root` or with `sudo`. Run it as a normal user with `sudo` privileges.

Clone this repo, change directory, make executable and run the script:

```bash
git clone https://github.com/Akashio28/Debian_Hyprland_dotfilesv2.git ~/Debian_Hyprland_dotfilesv2
cd ~/Debian_Hyprland_dotfilesv2
chmod +x install.sh
./install.sh
```

#### ✨ What the script does

1. Updates your package lists (`apt update`)
2. Installs Hyprland and core dependencies via `apt`
3. Installs `hyprpm` plugin build dependencies
4. Backs up any existing `~/.config/hypr` and related app configs to `~/.config-backup-<timestamp>/`
5. Copies the dotfiles into `~/.config`
6. Installs and enables the `hyprgrass` and `hyprexpo+` plugins via `hyprpm`

#### ✨ TO DO once installation is done

- `SUPER + H` for the keybind cheat sheet
- Reload Hyprland config with `hyprctl reload`
- Reboot or log out, then select **Hyprland** from your display manager

For more detailed steps, troubleshooting, and manual/partial installation, see [`INSTALL.md`](INSTALL.md).

---

## ⚙️ Migration Notes for Hyprland 0.55.2

Breaking changes already fixed in this config:

1. **`togglesplit` dispatcher removed** since 0.54 → replaced with `layoutmsg, togglesplit`

```ini
bind = $mainMod SHIFT, I, layoutmsg, togglesplit
```

2. **`dwindle:pseudotile`** removed in 0.55 (it wasn't doing anything) → removed from `UserSettings.conf`
3. **`misc:vfr`** moved to `debug:` (not meant for production use) → removed from `UserSettings.conf`
4. **Official `hyprexpo` plugin retired** from `hyprwm/hyprland-plugins` → replaced with the [`sandwichfarm/hyprexpo`](https://github.com/sandwichfarm/hyprexpo) fork ("hyprexpo+"), which adds keyboard navigation + workspace labels.

See [`CHANGELOG.md`](CHANGELOG.md) for the full history.

---

#### 🛣️ Roadmap

- [ ] Consider migrating config to Lua (optional, hyprlang is still supported for the next several releases)
- [ ] Clean up unused backup files (`*.bak`, `*-old.conf`)
- [ ] Add more wallpaper presets

---

#### 🙋 Having issues or questions?

- Open an issue on this repo: [Issues](https://github.com/Akashio28/Debian_Hyprland_dotfilesv2/issues)
- Refer to [`INSTALL.md`](INSTALL.md) for troubleshooting steps

---

#### 👍👍👍 Thanks and Credits

- [`Hyprland`](https://hyprland.org/) and [@vaxerski](https://github.com/vaxerski) for this awesome dynamic tiling Wayland compositor
- [`JaKooLit`](https://github.com/JaKooLit) for the original Hyprland-Dots this configuration is based on
- [`horriblename/hyprgrass`](https://github.com/horriblename/hyprgrass) and [`sandwichfarm/hyprexpo`](https://github.com/sandwichfarm/hyprexpo) for the plugins
- Wallpaper/illustration credits as noted in `assets/`

---

### 💖 Support

- A ⭐ on this repo would be appreciated!
- Follow [@Akashio28](https://github.com/Akashio28) on GitHub for more dotfiles and projects.

---

## 📄 License

No license specified. Feel free to use this configuration as a reference, but please credit the original [JaKooLit Hyprland-Dots](https://github.com/JaKooLit) project this is based on.

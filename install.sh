# 🚀 Installation Guide

This guide explains how to install **Debian Hyprland Dotfiles v2** on a fresh or existing Debian (apt-based) system.

---

## 1. Prerequisites

- A Debian-based system (Debian 13 "Trixie" or later recommended) with `apt` available
- A regular user account with `sudo` privileges
- `git` installed (`sudo apt install -y git`)
- Hyprland `v0.55.x` compatible system (see note below if you're on an older version)

> [!CAUTION]
> Do **NOT** run `install.sh` as `root` or with `sudo`. The script will call `sudo` itself when needed.

> [!TIP]
> It's recommended to back up your system (e.g. with `timeshift` or `snapper`) before making major desktop environment changes.

---

## 2. Clone the Repository

```bash
git clone https://github.com/Akashio28/Debian_Hyprland_dotfilesv2.git ~/Debian_Hyprland_dotfilesv2
cd ~/Debian_Hyprland_dotfilesv2
```

---

## 3. Run the Installer

```bash
chmod +x install.sh
./install.sh
```

### What the script does, step by step

1. **Pre-flight checks**
   - Refuses to run as root
   - Confirms `apt` is available (Debian/Ubuntu only)

2. **System update**
   - Runs `sudo apt update`

3. **Install Hyprland & core dependencies**
   - Installs Hyprland, Waybar, rofi, swaync, swww, kitty, thunar, and other core packages via `apt`

4. **Install hyprpm plugin build dependencies**
   - Installs the dev libraries needed to build/enable Hyprland plugins

5. **Backup existing configs**
   - If `~/.config/hypr` already exists, it's moved to `~/.config-backup-<timestamp>/hypr`
   - Existing configs for `waybar`, `rofi`, `swaync`, `kitty`, `wlogout`, `wallust` are backed up the same way

6. **Copy dotfiles**
   - Copies `hypr/` (and any other managed app config folders present in the repo) into `~/.config`
   - Makes scripts in `scripts/`, `UserScripts/`, and `initial-boot.sh` executable

7. **Install & enable plugins via hyprpm**
   - `hyprgrass` for touchscreen/trackpad gestures
   - `hyprexpo+` (community fork) for workspace overview

8. **Done**
   - Prints next steps and the location of your backed-up configs

---

## 4. After Installation

1. **Log out / reboot**, then select **Hyprland** from your display manager (or launch it manually).
2. Check for config errors:
   ```bash
   hyprctl reload
   ```
3. Open the keybind cheat sheet:
   ```
   SUPER + H
   ```

---

## 5. Manual / Partial Installation

If you only want specific parts of this setup:

### Just the Hyprland config

```bash
cp -r hypr ~/.config/hypr
```

### Just a specific app config

```bash
cp -r waybar ~/.config/waybar    # example
```

### Plugins only

```bash
hyprpm update
hyprpm add https://github.com/horriblename/hyprgrass
hyprpm add https://github.com/sandwichfarm/hyprexpo
hyprpm enable hyprgrass
hyprpm enable hyprexpo
hyprpm reload -n
```

---

## 6. Troubleshooting

### A package fails to install via `apt`

Some packages (e.g. `swww`, `hyprpicker`) may not be available in your distro's default repos depending on your release. If `apt` fails on a specific package:

- Install it manually / build from source, then re-run `./install.sh` — it's safe to re-run.

### `hyprpm` commands fail

- Run `hyprpm update` first, then retry `hyprpm add ...`
- Make sure the plugin build dependencies from step 4 above were installed successfully

### Hyprland doesn't start / returns to login manager

- Confirm you're running Hyprland `v0.55.x`. Older versions may not be compatible with this config — see [`CHANGELOG.md`](CHANGELOG.md) for breaking changes that were patched.
- Check `~/.config/hypr/UserConfigs/ENVariables.conf` for GPU-related environment variables if you have issues with rendering (especially NVIDIA).

### I want to restore my old config

Your previous config was backed up to:

```
~/.config-backup-<timestamp>/
```

Move it back into place, e.g.:

```bash
rm -rf ~/.config/hypr
mv ~/.config-backup-<timestamp>/hypr ~/.config/hypr
```

---

## 7. Updating

To pull the latest dotfiles:

```bash
cd ~/Debian_Hyprland_dotfilesv2
git pull
./install.sh
```

The script will back up your current config again before copying the new one, so nothing is lost.

To update plugins after a Hyprland update:

```bash
hyprpm update
hyprpm reload -n
```

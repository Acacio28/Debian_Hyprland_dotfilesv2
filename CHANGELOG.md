# Changelog

All notable changes to this dotfiles configuration are documented here.

---

## [Unreleased]

### Added
- `INSTALL.md` with detailed installation, troubleshooting, and update instructions
- `README.md` rewrite with folder structure overview, plugin table, and keybind summary

### Notes
- TODO: clean up unused `*.bak` / `*-old.conf` files left over from migration

---

## [2.0.0] - Hyprland v0.55.2 Migration

This release adapts the configuration (originally based on Acacio28's Hyprland-Dots) for compatibility with **Hyprland v0.55.2**, fixing several breaking changes introduced in recent Hyprland releases.

### Changed

- **`togglesplit` dispatcher**
  - The standalone `togglesplit` dispatcher was removed starting Hyprland 0.54.
  - Updated keybind in `UserConfigs/UserKeybinds.conf`:
    ```diff
    - bind = $mainMod SHIFT, I, togglesplit,
    + bind = $mainMod SHIFT, I, layoutmsg, togglesplit
    ```

- **`hyprexpo` plugin replaced with community fork**
  - The official `hyprexpo` plugin from `hyprwm/hyprland-plugins` has been retired/archived.
  - Replaced with [`sandwichfarm/hyprexpo`](https://github.com/sandwichfarm/hyprexpo) ("hyprexpo+"), which adds:
    - Keyboard navigation in the workspace overview
    - Workspace labels
  - Install via:
    ```bash
    hyprpm add https://github.com/sandwichfarm/hyprexpo
    hyprpm enable hyprexpo
    ```

### Removed

- **`dwindle:pseudotile`**
  - Removed in Hyprland 0.55; this setting had no effect since an earlier version anyway.
  - Removed from `UserConfigs/UserSettings.conf`.

- **`misc:vfr`**
  - Moved under the `debug:` category as it is not intended for production use.
  - Removed from `UserConfigs/UserSettings.conf`.

### Plugins

- `hyprgrass` (touchscreen/trackpad gestures) — unchanged, still maintained at [`horriblename/hyprgrass`](https://github.com/horriblename/hyprgrass)
- `hyprexpo+` (workspace overview) — new fork as noted above

---

## [1.0.0] - Initial Fork

- Initial configuration based on [Acacio28's Hyprland-Dots](https://github.com/Acacio28)
- Adapted for Debian (apt-based) systems
- Added `install.sh` with automatic backup of existing configs and `hyprpm` plugin setup

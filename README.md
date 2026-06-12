# Debian Hyprland Dotfiles v2

Personal Hyprland configuration, based on [JaKooLit Hyprland-Dots](https://github.com/JaKooLit), modified and adapted for **Hyprland v0.55.2** on Debian.

---

## 📋 Specs

- **Compositor**: Hyprland `v0.55.2`
- **Distro**: Debian
- **Config base**: JaKooLit dotfiles
- **Config language**: Hyprlang (`.conf`)

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

| Plugin | Repo | Purpose |
|---|---|---|
| `hyprgrass` | [horriblename/hyprgrass](https://github.com/horriblename/hyprgrass) | Touchscreen/trackpad gestures (swipe to switch workspaces) |
| `hyprexpo` (fork) | [sandwichfarm/hyprexpo](https://github.com/sandwichfarm/hyprexpo) | Workspace overview (expo) — community fork, since the official plugin was retired as of Hyprland 0.55 |

### Install plugins
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

| Keybind | Action |
|---|---|
| `SUPER + Return` | Open terminal |
| `SUPER + D` | App launcher (rofi) |
| `SUPER + E` | File manager |
| `SUPER + Q` | Close active window |
| `SUPER + W` | Select wallpaper |
| `SUPER + R` | Random wallpaper |
| `SUPER + A` | Workspace overview (hyprexpo+) |
| `SUPER + SHIFT + I` | Toggle split (dwindle) |
| `SUPER + SPACE` | Toggle floating |
| `SUPER + SHIFT + F` | Fullscreen |
| `SUPER + N` | Toggle night light (hyprsunset) |
| `SUPER + H` | Keybind cheat sheet |
| `3-finger swipe` | Switch workspace (hyprgrass) |

---

## ⚙️ Migration Notes for Hyprland 0.55.2

Breaking changes already fixed in this config:

1. **`togglesplit` dispatcher removed** since 0.54 → replaced with `layoutmsg, togglesplit`
   ```
   bind = $mainMod SHIFT, I, layoutmsg, togglesplit
   ```

2. **`dwindle:pseudotile`** removed in 0.55 (it wasn't doing anything) → removed from `UserSettings.conf`

3. **`misc:vfr`** moved to `debug:` (not meant for production use) → removed from `UserSettings.conf`

4. **Official `hyprexpo` plugin retired** from `hyprwm/hyprland-plugins` → replaced with the [`sandwichfarm/hyprexpo`](https://github.com/sandwichfarm/hyprexpo) fork ("hyprexpo+"), which is actively maintained and adds keyboard navigation + workspace labels.

---

## 🚀 Installation (on a new machine)

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

## 📝 TODO / Notes

- [ ] Consider migrating config to Lua (optional, hyprlang is still supported for the next several releases)
- [ ] Clean up unused backup files (`*.bak`, `*-old.conf`)

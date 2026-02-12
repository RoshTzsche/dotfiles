I'm currently working on this... 

# 🏛️ Dotfiles | CachyOS + Hyprland

![Hero Shot](assets/hero.png)

> "Civilize the mind, but make savage the body"

## 📜 My Philosophy
A configuration focused on pure performance and adaptive aesthetics, with custom scripts. 
CPU: **Ryzen 6800H** 
GPU: **RTX 3070**
* **Base System:** CachyOS (Optimized Arch Linux)
* **WM:** Hyprland (Dwindle Layout)
* **Colors:** Pywal (Dynamic generation based on wallpaper)
* **Typography:** JetBrains Mono Nerd Font

## 🖼️ Gallery - NOT FINISHED

### Productivity Mode (Dynamic Tiling)
![Busy Shot](assets/busy.png)

### 🌑 Reading Mode (E-Ink Shader)
A key feature is the custom GLSL shader that simulates electronic ink to reduce eye strain. It uses deterministic logic (Bayer matrices) to simulate paper grain and ink bleed. Inspired in the dotfiles from [snes19xx](https://github.com/snes19xx/surface-dots)
![Reading Mode](assets/reading.png)
*(Custom script that toggles shaders, shadows, and blur on-the-fly)*

## 🛠️ Tech Stack

| Component | Tool | Notes |
| :--- | :--- | :--- |
| **Shell** | Fish | Configured with `mamba` for Python environments |
| **Bar** | Waybar | Modular JSONC with custom scripts (Nvidia, Pomodoro) |
| **Editor** | Neovim | Lazy.nvim, LSP (Pyright, Lua_ls), Obsidian integration |
| **Launcher** | Wofi/Rofi | Custom launcher scripts |
| **Terminal** | Kitty | GPU accelerated, controlled via socket |
| **Compositor** | Hyprland | `easeOutQuint` animations, `dwindle` layout |

## ✨ Unique Features

* **Hybrid GPU Handling:** Custom scripts to monitor the RTX 3070 (temperature, usage, VRAM) in Waybar, only active when the dGPU is awake.
* **Wallpaper Engine:** `set_wallpaper.sh` script that manages `hyprpaper`, generates `pywal` color schemes, and reloads `waybar`, `kitty`, and `dunst` instantly.
* **Obsidian Neovim:** Zettelkasten workflow integrated directly into the editor.
* **True Reading Mode:** Mathematical implementation of noise and paper grain to simulate real reading conditions.

## 📦 Installation

This repository uses **GNU Stow** to manage symlinks.

```bash
# 1. Clone the repo
git clone [https://github.com/YOUR_USERNAME/dotfiles.git](https://github.com/YOUR_USERNAME/dotfiles.git) ~/dotfiles

# 2. Install dependencies (Partial list)
sudo pacman -S hyprland waybar kitty fish neovim stow pywal

# 3. Deploy configurations
cd ~/dotfiles
stow fish
stow hypr
stow kitty
stow nvim
stow waybar
stow scripts

```

## ⌨️ Keybindings

| Key | Action |
| --- | --- |
| `SUPER + Q` | Terminal (Kitty) |
| `SUPER + E` | File Manager (Dolphin) |
| `SUPER + W` | Change Wallpaper (Random + Pywal) |
| `SUPER + D` | Toggle Reading Mode (E-Ink) |
| `SUPER + F` | Zen Mode |
| `SUPER + L` | Hyprlock |

---
# UNIFINISHED STUFF
### 🍅 Time Management (Waybar Pomodoro) _UNFINISHED
Custom Waybar module written in Python with notification integration and visual controls.
![Pomodoro](assets/pomodoro.png)

*by RoshTzsche.*

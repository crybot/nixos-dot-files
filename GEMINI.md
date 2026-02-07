# Gemini Context: NixOS & Chezmoi Dotfiles

This repository contains a hybrid configuration system using **NixOS Flakes** for system-level management and **Chezmoi** for managing dotfiles and secrets. It supports multiple hosts (Desktop, Laptop) with a consistent, themed user environment.

## Project Overview

*   **Type:** Infrastructure as Code (NixOS) + Dotfiles Management.
*   **Core Technologies:**
    *   **NixOS:** System configuration using Flakes.
    *   **Home Manager:** User environment management (integrated as a NixOS module).
    *   **Chezmoi:** Manages specific dotfiles (`~/.config`) and likely secrets/private configs.
    *   **Hyprland:** Wayland compositor (Window Manager).
    *   **Catppuccin:** Global theme (Mocha flavor, Mauve accent).
*   **Hosts:**
    *   `nixos-desktop`: Desktop configuration with Nvidia drivers and CUDA support.
    *   `nixos-laptop`: Laptop configuration (likely with specific power management).

## Directory Structure

*   `nixos-config/`: **Core NixOS Configuration**
    *   `flake.nix`: Entry point. Defines `nixosConfigurations` for `nixos-desktop` and `nixos-laptop`.
    *   `configuration.nix`: Shared system configuration.
    *   `home/`: **Home Manager Modules**
        *   Contains modular configs for `hyprland`, `neovim`, `waybar`, `fish`, `rofi`, etc.
        *   `default.nix`: Main Home Manager entry point, importing other modules and setting themes.
    *   `hosts/`: **Host-Specific Configs**
        *   `desktop/`: Includes `desktop.nix` (Nvidia settings, hardware config).
        *   `laptop/`: Includes `laptop.nix`.
    *   `modules/`: Custom Nix modules (e.g., `anythingllm`).
*   `dot_config/`: **Chezmoi Source**
    *   Contains configuration files that are applied to `~/.config` via `chezmoi apply`.
    *   Examples: `btop`, `nvim` backups, `private_srain`.

## Usage & Workflow

### 1. System Rebuild (NixOS)
To apply changes made in `nixos-config/`:

```bash
# Rebuild the system for the current hostname
sudo nixos-rebuild switch --flake ~/nixos-config#$(hostname)

# Or explicitly for a specific host
sudo nixos-rebuild switch --flake ~/nixos-config#nixos-desktop
```

### 2. Dotfiles Management (Chezmoi)
To apply changes from `dot_config/` or add new files:

```bash
# Apply changes to the home directory
chezmoi apply

# Edit a file managed by chezmoi
chezmoi edit ~/.config/some/file

# Update chezmoi source from the repo (if using git inside chezmoi)
chezmoi update
```

### 3. Installation (Bootstrap)
On a fresh NixOS install:

```bash
# 1. Enter shell with chezmoi
nix-shell -p chezmoi

# 2. Initialize and apply dotfiles
chezmoi init crybot/nixos-dot-files --apply

# 3. Copy hardware config
sudo cp /etc/nixos/hardware-configuration.nix ~/nixos-config/hosts/<hostname>/

# 4. Build system
sudo nixos-rebuild switch --flake ~/nixos-config#<hostname>
```

## Configuration Details

*   **Window Manager:** Hyprland (configured in `nixos-config/home/hyprland/`).
*   **Shell:** Fish (configured in `nixos-config/home/fish/`), with `eza` as `ls` and `bat` as `cat`.
*   **Editor:** Neovim (managed via Home Manager in `nixos-config/home/neovim/`).
*   **Terminal:** Alacritty (primary), Kitty, Foot.
*   **Theme:** Catppuccin Mocha (Mauve accent) applied globally via Nix module.
*   **Scripts:** Custom scripts (e.g., screenshot, rofi menus) are located in `nixos-config/home/rofi/` and linked to `~/scripts/` or `~/.local/bin/` via Home Manager.

## Key Files
*   `nixos-config/flake.nix`: The definitions of the system.
*   `nixos-config/home/default.nix`: Central file for user packages and Home Manager settings.
*   `nixos-config/hosts/desktop/desktop.nix`: Desktop-specifics (Nvidia, etc.).
*   `README.md`: Contains manual steps for secrets (Lastpass, Dropbox) and post-install setup.

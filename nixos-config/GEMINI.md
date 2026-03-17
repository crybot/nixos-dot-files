# NixOS Configuration

This repository contains the NixOS configuration for `crybot`'s systems (`nixos-desktop` and `nixos-laptop`), managed via **Nix Flakes** and **Home Manager**.

## Architecture

The project is structured to separate system-level configuration, user-level configuration, and hardware specifics.

*   **`flake.nix`**: The entry point. Defines inputs (nixpkgs, home-manager, catppuccin) and outputs (`nixosConfigurations`).
*   **`hosts/`**: Contains machine-specific configurations.
    *   `desktop/`: Settings for the main workstation (`nixos-desktop`). Includes Nvidia drivers, kernel tweaks, and hardware config.
    *   `laptop/`: Settings for the portable machine (`nixos-laptop`).
*   **`home/`**: User-space configuration managed by Home Manager.
    *   `default.nix`: The main home manager configuration file for user `crybot`.
    *   **Submodules**: Configuration for specific tools is modularized (e.g., `hyprland/`, `waybar/`, `neovim/`, `fish/`).
*   **`modules/`**: Custom Nix modules and packages.
    *   `anythingllm-app/`: A custom wrapper to run AnythingLLM via Docker.

## Key Technologies & Preferences

*   **OS:** NixOS (tracking `nixos-unstable` for packages).
*   **Window Manager:** Hyprland (`home/hyprland`).
*   **Shell:** Fish (`home/fish`).
*   **Editor:** Neovim (`home/neovim`).
*   **Theme:** Catppuccin Mocha (Mauve accent). Applied consistently across GTK, Hyprland, Waybar, etc.
*   **Terminal:** Alacritty, Kitty, Foot.
*   **Browser:** Firefox.

## Development & Management

### Rebuilding the System
To apply changes to the system or home manager configuration:

```bash
# For Desktop
sudo nixos-rebuild switch --flake .#nixos-desktop

# For Laptop
sudo nixos-rebuild switch --flake .#nixos-laptop
```

### Updating Dependencies
To update the flake inputs (e.g., `nixpkgs` version):

```bash
nix flake update
```

### Formatting
The project seems to use standard Nix formatting (likely `nixfmt` or `alejandra` - check `flake.nix` devShell if available).

## Custom Modules

*   **AnythingLLM Desktop:** A custom module (`programs.anythingllm-desktop`) that wraps a Docker container. Currently disabled in `hosts/desktop/desktop.nix`.
*   **Hyprsunset:** Custom overlay/service for blue light filtering.

## Important Notes

*   **Nvidia:** The desktop config enables Nvidia proprietary drivers and the container toolkit.
*   **Swap:** The desktop has a large (64GB) swap file configured.
*   **Gemini CLI:** The `gemini-cli` is configured in `home/default.nix`.

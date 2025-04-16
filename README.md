# Installation
On a NixOS system run:
```bash
HOST_NAME=<your-hostname> # Choose a hostname that matches one of the available configurations
nix-shell -p chezmoi  # Load a shell environment with chezmoi
chezmoi init crybot/nixos-dot-files --apply  # Pull the dot-files and apply them: this will also create a nix-config/ directory in your home
sudo cp /etc/nixos/hardware-configuration.nix ~/nixos-config/hosts/$HOST_NAME/  # Copy your actual hardware configuration
sudo nixos-rebuild switch --flake ~/nixos-config#$HOST_NAME  # Build the system
```
Then reboot. Subsequent `nixos-rebuild`s will not need you to tag the flake with `#$HOST_NAME`.

## Optional steps
To complete the installation you need to log into:
- Lastpass (firefox)
- Dropbox (to sync Zotero and Obsidian data)
- Zotero (to pull library information)

To use obsidian simply select the Vault under the directory `"~/Dropbox/Obsidian/Main Vault"`

Zotmoov is installed automatically through home-manager. User preferencces are set in `user.js.template`.
There's no real need to manually configure file renaming (which was previously done by zotfile), because starting from Zotero 7 this is handled by default.

## Neovim
Neovim plugins and language servers are managed through nix and home-manager.

## TODO:
- ~Manage neovim through a home-managed lua file~
- ~Install language servers and build tools with nix~
- ~Install neovim plugins through nix (?)~

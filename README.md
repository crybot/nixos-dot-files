# Installation
On a NixOS system run:
```bash
HOST_NAME=<your-hostname> # Choose a hostname that matches one of the available configurations
nix-shell -p chezmoi  # Load a shell environment with chezmoi
chezmoi init crybot/nixos-dot-files --apply  # Pull the dot-files and apply them: this will also create a nix-config/ directory in your home
sudo cp /etc/nixos/hardware-configuration.nix ~/nixos-config/hosts/$HOST_NAME/  # Copy your actual hardware configuration
sudo nixos-rebuild switch --flake ~/nixos-config#$HOST_NAME  # Build the system
```
Then reboot. Subsequent `nixos-rebuild`a will not need you to tag the flake with #$HOST_NAME.

## Optional steps
To complete the installation you need to log into:
- Lastpass (firefox)
- Dropbox (to sync Zotero and Obsidian data)
- Zotero (to pull library information)

To use obsidian simply select the Vault under the directory `"~/Dropbox/Obsidian/Main Vault"`

Finally, install Zotmoov (which replaces zotfile) plugin for Zotero, which lets you automatically move retrieved documents into the Dropbox folder.
There's no real need to manually configure file renaming (which was previously done by zotfile), because starting from Zotero 7 this is handled by default.

## Neovim
Neovim is still managed by chezmoi with a dot file, which means the plugin manager, the plugins and the language servers
will not come preinstalled. To correctly set them up do the following:

1. Launch neovim once, it will spit a bunch of errors and automatically download vim-plug.
2. Launch neovim again and run `:PlugInstall` to install the plugins.
3. Launch neovim a third time to install the language servers. You can run `:Mason` to see the progress.


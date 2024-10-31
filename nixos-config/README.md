# Installation
On a NixOS system run:
```bash
HOST_NAME=<your-hostname> # Choose the hostname so that it matches one of the available configuration (./hosts) so that you won't need to select the right configuration for every rebuild. 
nix-shell -p chezmoi  # Load a shell environment with chezmoi
chezmoi init crybot/nixos-dot-files --apply  # Pull the dot-files and applies them: this will also create a nix-config/ directory in your home
sudo cp /etc/nixos/hardware-configuration.nix ~/nixos-config/hosts/$HOSTNAME/  # Copy your actual hardware configuration
sudo nixos-rebuild switch --flake ~/nixos-config#$HOSTNAME  # Build the system
```
Then reboot.

## Optional steps
To complete the installation you need to log into:
- Lastpass (firefox)
- Dropbox (to sync Zotero and Obsidian data)
- Zotero (to pull library information)

To use obsidian simply select the Vault under the directory `"~/Dropbox/Obsidian/Main Vault"`

Finally, install Zotmoov (which replaces zotfile) plugin for Zotero, which lets you automatically move retrieved documents into the Dropbox folder.
There's no real need to manually configure file renaming (which was previously done by zotfile), because starting from Zotero 7 this is handled by default.

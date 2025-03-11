{ config, pkgs, lib, ... }:

{
  imports = [
    ./neovim/default.nix
    ./hyprland/default.nix
    ./firefox/default.nix
    ./waybar/default.nix
    ./fish/default.nix
    ./rofi/default.nix
  ];

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "crybot";
  home.homeDirectory = "/home/crybot";

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    playerctl
  ];

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  catppuccin.flavor = "mocha";
  catppuccin.enable = true;
  catppuccin.pointerCursor.enable = true;
  gtk.enable = true;
  gtk.catppuccin.flavor = "macchiato";
  gtk.catppuccin.enable = true;

  programs = {
    bash.enable = true;
    kitty.enable = true;
    foot.enable = true;
    git = {
      enable = true;
      userName  = "crybot";
      userEmail = "crybot@hotmail.it";
    };
  };

  programs.alacritty = {
    enable = true;
    catppuccin.enable = true;
    catppuccin.flavor = "mocha"; #TODO: also test "macchiato"

    settings = {
      font = {
        normal = {
          family = "FiraCode Nerd Font";
          style = "Regular";
        };
        size = 13.0;
      };

      colors = {
        draw_bold_text_with_bright_colors = true;
      };

      terminal = {
        shell = "fish";
      };

      window = {
        dynamic_padding = true;
      };
    };
  };

  programs.bat = {
    enable = true;
    catppuccin.enable = true;
    catppuccin.flavor = "mocha";
  };

  services.swaync = {
    enable = true;
  };

  services.gammastep = {
    enable = true;
    provider = "manual";
    latitude = "41.902782";
    longitude = "12.496365";
    tray = true;
    temperature = {
      day = 5500;
      night = 3500;
    };
  };

  home.shellAliases = {
    cz = "chezmoi";
    cat = "bat";
  };

}

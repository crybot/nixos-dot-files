{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    catppuccin.enable = true;
    catppuccin.flavor = "mocha";
    catppuccin.accent = "mauve";
    extraConfig = builtins.readFile ./hyprland.conf;
  };

}

{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = false;
    catppuccin.enable = true;
    catppuccin.flavor = "mocha";
    catppuccin.accent = "mauve";
    extraConfig = builtins.readFile ./hyprland.conf;
    # plugins = [ pkgs.hyprlandPlugins.hyprspace ];
  };

}

{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    extraConfig = builtins.readFile ./hyprland.conf;
    # plugins = [ pkgs.hyprlandPlugins.hyprspace ];
  };

}

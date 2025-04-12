{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = false;
    extraConfig = builtins.readFile ./hyprland.conf;
    # plugins = [ pkgs.hyprlandPlugins.hyprspace ];
  };

}

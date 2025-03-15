{ config, pkgs, lib, ... }:

{
  imports = [
  ];

  programs.alacritty = {
    settings =  {
      font = {
        size = lib.mkForce 11.6;
      };
    };
  };

  wayland.windowManager.hyprland = {
    systemd.enable = false;
    settings = {
      cursor = {
        no_hardware_cursors = true;
      };
      monitor = [
        "HDMI-A-1, disable"
        "HDMI-A-2, disable"

      ];
      # https://wiki.hyprland.org/Configuring/Variables/#blur
      decoration = {
        blur = {
          # To enable blur on waybar we need to also set a transparent color in waybar's style.css, but this would
          # require replicate style.css under each other configuration that does not use blur.
          enabled = true; 
          size = 6;
          passes = 2;
          ignore_opacity = true;
          new_optimizations = true;
          noise = 0.0117;
          vibrancy = 0.1696;
          popups = true;
        };
      };
      windowrulev2 = [
        "opacity 0.7 override 0.7 override 0.7 override, class:(blueman)"
        "opacity 0.7 override 0.7 override 0.7 override, class:(nm-connection-editor)"
        "opacity 0.7 override 0.7 override 0.7 override, class:(nm-applet)"
        "opacity 0.7 override 0.7 override 0.7 override, class:(io.github.kaii_lb.Overskride)"
      ];
      layerrule = [ 
        "blur, waybar" # Add blur to waybar
        "blurpopups, waybar "# Blur waybar popups too!
        "ignorealpha 0.2, waybar "# Make it so transparent parts are ignored
      ];
    };
  };

}

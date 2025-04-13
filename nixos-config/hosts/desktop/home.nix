{ config, pkgs, lib, ... }:

{
  imports = [
  ];

  programs.alacritty = {
    settings =  {
      font = {
        size = lib.mkForce 12.0;
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
          passes = 4;
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
        "opacity 0.90 override, class:(Alacritty)"
      ];
      layerrule = [ 
        "blur, waybar" # Add blur to waybar
        "blurpopups, waybar"# Blur waybar popups too!
        "ignorealpha 0.2, waybar "# Make it so transparent parts are ignored
        "blur, rofi" 
        "ignorezero, rofi"
        "dimaround, rofi"
        "blurpopups, rofi"
      ];
    };

    extraConfig = ''
      exec-once = pkill swaybg
      exec-once = swaybg --output "DP-5" -i ~/Pictures/backgrounds/sukuna-catppuccin1-hq2.png --mode stretch
      exec-once = swaybg --output "DP-4" -i ~/Pictures/backgrounds/sukuna-catppuccin2-hq2.png --mode stretch
      '';
  };

  # TODO: set persistent workspaces
  # programs.waybar = {
  #   settings = {
  #     mainBar = {
  #       "hyprland/workspaces" = {
  #         format = "{icon}";
  #         on-click = "activate";
  #         format-icons = {
  #           active = " ";
  #         };
  #         persistent-workspaces = {
  #           "DP-4" = [1 2 3];
  #           "DP-5" = [4 5 6];
  #         };
  #         sort-by-number = true;
  #       };
  #     };
  #   };
  # };

}

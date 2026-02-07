{ config, pkgs, lib, ... }:

{
  imports = [
  ];

  programs.alacritty = {
    settings =  {
      font = {
        size = lib.mkForce 13.0;
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
          passes = 3;
          ignore_opacity = true;
          new_optimizations = true;
          noise = 0.0117;
          vibrancy = 0.1696;
          popups = true;
        };
      };
      windowrule = [
          # Syntax: effect value, match:prop regex
          "opacity 0.7 0.7 0.7, match:class ^(blueman)$"
          "opacity 0.7 0.7 0.7, match:class ^(nm-connection-editor)$"
          "opacity 0.7 0.7 0.7, match:class ^(nm-applet)$"
          "opacity 0.7 0.7 0.7, match:class ^(io.github.kaii_lb.Overskride)$"
          
          # "opacity 1.0 override" becomes just "opaque" or "opacity 1.0"
          "opacity 1.0 1.0 1.0, match:class ^(Alacritty)$"
        ];

        layerrule = [
          # Syntax: effect value, match:namespace regex
          "blur on, match:namespace ^(waybar)$"
          "blur_popups on, match:namespace ^(waybar)$"
          "ignore_alpha 0.2, match:namespace ^(waybar)$"
          
          "blur on, match:namespace ^(rofi)$"
          "ignore_alpha 0, match:namespace ^(rofi)$" # ignorezero replaced by ignore_alpha 0
          "dim_around on, match:namespace ^(rofi)$"
          "blur_popups on, match:namespace ^(rofi)$"
        ];
    };

    extraConfig = ''
        exec-once = pkill swaybg
        exec-once = mpvpaper -o "no-audio --loop --hwdec=auto --speed=0.625" "*" ~/Pictures/backgrounds/sukuna-version5-96fps.mp4
    '';

    # extraConfig = ''
    #   exec-once = pkill swaybg
    #   exec-once = swaybg --output "DP-5" -i ~/Pictures/backgrounds/sukuna-catppuccin1-hq2.png --mode stretch
    #   exec-once = swaybg --output "DP-4" -i ~/Pictures/backgrounds/sukuna-catppuccin2-hq2.png --mode stretch
    # '';
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

  # AnythinLLM setup
  # anythingllm.enable = true;
  # anythingllm.storagePath = "/var/lib/anythingllm";
  # anythingllm.composeFile = "/etc/anythingllm/docker-compose.yml";

}

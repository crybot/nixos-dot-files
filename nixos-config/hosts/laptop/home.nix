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

  programs.hyprlock.enable = true;
  programs.hyprlock.settings = {
    # GENERAL
    general = {
      disable_loading_bar = true;
      hide_cursor = true;
    };

    # BACKGROUND
    background = [
      {
        path = "$HOME/Pictures/backgrounds/dabi3.jpg";
        blur_passes = 2;
        blur_size = 6;
      }
    ];

    # INPUT FIELD
    input-field = [
      {
        monitor = "";
        size = "350, 80";
        outline_thickness = 2;
        dots_size = 0.2;
        dots_spacing = 0.35;
        dots_center = true;
        font_family = "JetBrains Mono";
        outer_color = "rgba(0, 0, 0, 0)";
        inner_color = "rgba(0, 0, 0, 0.2)";
        font_color = "rgba(255, 255, 255, 1.0)";
        fade_on_empty = false;
        rounding = -1;
        check_color = "rgb(204, 136, 34)";
        placeholder_text = "Password";
        hide_input = false;
        position = "0, -220";
        halign = "center";
        valign = "center";
      }
    ];

    label = [
      # DATE
      {
        monitor = "";
        text = "cmd[update:1000] LC_TIME=en_US.UTF-8 date +\"%A, %B %d\"";
        color = "rgba(242, 243, 244, 0.75)";
        font_size = 32;
        font_family = "JetBrains Mono";
        position = "0, 700";
        halign = "center";
        valign = "center";
      }
      # TIME
      {
        monitor = "";
        text = "cmd[update:1000] date +\"%-H:%M\"";
        color = "rgba(242, 243, 244, 0.75)";
        font_size = 124;
        font_family = "JetBrains Mono Extrabold";
        position = "0, 600";
        halign = "center";
        valign = "center";
      }
      # GREETING
      { 
        monitor = "";
        text = "Hello, crybot";
        color = "$foreground";
        font_size = 26;
        font_family = "JetBrains Mono Italic";
        position = "0, 135";
        halign = "center";
        valign = "center";
      }
    ];

    image  = [
    # PROFILE PICTURE
      {
        monitor = "";
        path = "$HOME/Pictures/backgrounds/bakugo2.jpg";
        size = 200;
        border_size = 5;
        border_color = "rgba(255, 255, 255, 0.8)";
        position = "0, -60";
        halign = "center";
        valign = "center";
        rounding = -1;
      }
    ];



  };

  wayland.windowManager.hyprland = {
    systemd.enable = false;
    settings = {
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
    # Long pressing XF86Tools (F10) doesn't work on this laptop: it gets immediately released for some reason
    # (unlike other XF86 keys). Luckily it also generates a right keypress and release for key with code 248, which
    # we will use instead.
    extraConfig = ''
        # Long press disables vpn
        bindo = $mainMod, code:248, exec, sudo $HOME/scripts/stop-wireguard.sh
        # Short press enables vpn
        bind = $mainMod, code:248, exec, sudo $HOME/scripts/start-wireguard.sh
      '';
  };

  home.file."scripts/start-wireguard.sh" = {
    source = pkgs.replaceVars ./wireguard/start-wireguard.sh.template { wgInterface = "wg0"; };
    executable = true;
  };

  home.file."scripts/stop-wireguard.sh" = {
    source = pkgs.replaceVars ./wireguard/stop-wireguard.sh.template { wgInterface = "wg0"; };
    executable = true;
  };

}

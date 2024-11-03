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
    settings = {
      # https://wiki.hyprland.org/Configuring/Variables/#blur
      decoration = {
        blur = {
          # To enable blur on waybar we need to also set a transparent color in waybar's style.css, but this would
          # require replicate style.css under each other configuration that does not use blur.
          enabled = false; 
        };
      };
    };
  };


}

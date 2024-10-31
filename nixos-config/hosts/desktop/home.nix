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
    settings = {
      cursor = {
        no_hardware_cursors = true;
      };
      monitor = [
        "HDMI-A-1, disable"
      ];
    };
  };

}

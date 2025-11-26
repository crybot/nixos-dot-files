{ config, pkgs, lib, ...}:

{
  programs.rofi = {
    enable = true;
    # package = pkgs.rofi-wayland;
    package = pkgs.rofi;
    extraConfig = {
      modi = "run,drun,window,keys,filebrowser";
      icon-theme = "Oranchelo";
      show-icons = true;
      terminal = "alacritty";
      drun-display-format = "{icon} {name}";
      disable-history = false;
      hide-scrollbar = true;
      display-drun = "   Apps ";
      display-run = "   Run ";
      display-window = " 󰕰  Window";
      display-Network = " 󰤨  Network";
      display-keys = "   Keys";
      display-filebrowser = "   Files";
      sidebar-mode = true;
    };
    location = "center";
    theme = ./rounded.rasi;
  };

}

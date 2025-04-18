{ config, pkgs, lib, ...}:
{
  programs.waybar = {
    enable = true;
    style = builtins.readFile ./style.css; # prependImport only works if this is a string
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 31;
        spacing = 10;
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "hyprland/window" ];
        modules-right = [ 
          "pulseaudio"
          "network"
          # "cpu"
          "backlight"
          "battery"
          "clock"
          "tray"
          # "bluetooth"
          "power-profiles-daemon"
          "custom/power"
        ];

        "hyprland/window" = {
          separate-outputs = true;
        };

        "tray" = {
          icon-size = 15;
          spacing = 10;
        };

        "clock" = {
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format-alt = "{:%Y-%m-%d}";
        };

        "cpu" = {
          format = "  {usage}%";
          tooltip = true;
        };

        "backlight" = {
          format = "{percent}% {icon} ";
          format-icons = ["" "" "" "" "" "" "" ""];
        };

        "battery" = {
          states = {
            "good" = 60;
            "warning" = 40;
            "critical" = 20;
          };
          format = "{capacity}% {icon}";
          format-full = "{capacity}% {icon}";
          format-charging = "{capacity}%  ";
          format-plugged = "{capacity}% ";
          format-alt = "{time} {icon}";
          format-icons = [" " " " " " " " " "];
          interval = 5;
        };

        "power-profiles-daemon" = {
          format = " {icon}";
          tooltip-format = "Power profile: {profile}\nDriver: {driver}";
          tooltip = true;
          format-icons = {
            default = "";
            performance = "";
            balanced = "";
            power-saver = "";
          };
        };

        "network" = {
          format-wifi = "{essid} ({signalStrength}%)  ";
          format-ethernet = "{ipaddr}/{cidr} ";
          tooltip-format = "{ifname} via {gwaddr} ";
          format-linked = "{ifname} (No IP) ";
          format-disconnected = "Disconnected ⚠";
          format-alt = "{ifname} = {ipaddr}/{cidr}";
        };

        "pulseaudio" = {
          format = "{icon} {volume}% {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = "  {icon} {format_source}";
          format-muted = "  {format_source}";
          format-source = " {volume}%";
          format-source-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = ["" "" " "];
          };
          on-click = "pavucontrol";
        };

        bluetooth = {
          on-click = "overskride";
          format-on = "󰂯";
          format-off = "󰂲";
          format-disabled = "󰂲";
          format-connected = "󰂱";
          tooltip-format-connected = "{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
        };

        "hyprland/workspaces" = {
          format = "{icon}";
          on-click = "activate";
          format-icons = {
            active = " ";
            # urgent = " ";
          };
          sort-by-number = true;
        };

        "custom/power" = {
          format  = "⏻ ";
          tooltip = false;
          menu = "on-click";
          menu-file = ./power_menu.xml;
          menu-actions = {
            shutdown = "shutdown";
            reboot = "reboot";
            suspend = "systemctl suspend";
            hibernate = "systemctl hibernate";
          };
        };
      };
    };
  };

}

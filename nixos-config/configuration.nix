# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

#TODO: blueman, redshift
#TODO: firefox with extensions (ublock, lastpass)

#TODO: move common stuff for all hosts here, including home-manager configs

{ config, pkgs, lib, ... }:
let
  # Override obsidian with a wrapped version that fixes fractional scaling in wayland
  obsidianWithFlag = pkgs.writeShellScriptBin "obsidian" ''
    #!/bin/sh
    exec ${pkgs.obsidian}/bin/obsidian --enable-features=UseOzonePlatform --ozone-platform=wayland "$@"
  '';
  telegramGnome = pkgs.writeShellScriptBin "telegram-desktop" ''
      #!/bin/sh 
      XDG_CURRENT_DESKTOP=gnome exec ${pkgs.telegram-desktop}/bin/telegram-desktop "$@"
  '';
in
{
  imports =
    [ 
    ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  swapDevices = [{
      device = "/swapfile";
      size = 16 * 1024; # 16GB
    }];

  catppuccin.flavor = "mocha";
  catppuccin.enable = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # networking.hostName = "nixos-laptop"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Rome";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "it_IT.UTF-8";
    LC_IDENTIFICATION = "it_IT.UTF-8";
    LC_MEASUREMENT = "it_IT.UTF-8";
    LC_MONETARY = "it_IT.UTF-8";
    LC_NAME = "it_IT.UTF-8";
    LC_NUMERIC = "it_IT.UTF-8";
    LC_PAPER = "it_IT.UTF-8";
    LC_TELEPHONE = "it_IT.UTF-8";
    LC_TIME = "it_IT.UTF-8";
  };

  # Configure keymap in X11
  # NOTE: Wayland compositors (hyprland, sway, etc.) still require you to set kb options through their configuration
  # files because of isolated input handling
  services.xserver.xkb = {
    layout = "us";
    variant = "";
    options = "compose:rctrl";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.crybot = {
    isNormalUser = true;
    description = "Marco";
    extraGroups = [ "networkmanager" "wheel" "docker"];
    packages = with pkgs; [];
  };

  systemd.packages = with pkgs; [
    gdm
    gnome-session
    gnome-shell
  ];

  # List packages installed in system profile. To search, run: nix search <package>
  environment.systemPackages = with pkgs; [
    wget git
    vim 
    wl-clipboard
    kitty 
    fish 
    rofi-wayland
    waybar
    gcc clang
    python3
    firefox
    nodejs
    swaybg
    swaynotificationcenter libnotify
    brightnessctl
    networkmanagerapplet
    telegramGnome
    cargo
    btop htop powertop
    hyprshot
    google-chrome
    pavucontrol
    neofetch
    chezmoi
    zotero
    nautilus
    obsidianWithFlag # unfree
    dropbox # unfree
    image-roll
    mpv
    waypaper
    adwaita-icon-theme
  ];

  # Hint Electron apps to use Wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
    xdgOpenUsePortal = true;
    config = lib.mkDefault {
      common = {
        default = [
          "gtk"
        ];
        "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
      };
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

  programs.hyprland.enable = true;

  services.xserver = {
    enable = true;
  };

  services.libinput.enable = true;

  hardware.graphics = {
    enable = true;
  };

  programs.fish = {
    enable = true;
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
  };

  security.sudo = {
    enable = true;
    extraConfig = ''
      Defaults timestamp_timeout=30
      Defaults env_keep += "XDG_RUNTIME_DIR"
      Defaults env_keep += "WAYLAND_SOCKET"
      Defaults env_keep += "WAYLAND_DISPLAY"
    '';
  };
  fonts.packages = with pkgs; [
    noto-fonts
    nerdfonts
    font-awesome
    powerline-fonts
    powerline-symbols
  ];

  # Fixes dynamic libraries for unpackaged binaries
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
  ];

  # Remove sound.enable or set it to false if you had it set previously, as sound.enable is only meant for ALSA-based configurations
  # rtkit is optional but recommended ("Whether to enable the RealtimeKit system service, which hands out realtime
  # scheduling priority to user processes on demand. For example, the PulseAudio server uses this to acquire realtime
  # priority")
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  services.power-profiles-daemon.enable = true;
  services.gvfs.enable = true;

  # Docker
  virtualisation.docker = {
    enable = true;
    # Uncomment if you want to run docker rootless (need to set variable DOCKER_HOST each time)
    # rootless = {
    #   enable = true;
    #   setSocketVariable = true;
    # };
    daemon.settings = {
      data-root = "/data/docker";
    };
  };
}

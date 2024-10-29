# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

#TODO: blueman, flakes, home-manager, dropbox, obsidian, zotero, redshift

{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
  catppuccin = builtins.fetchTarball "https://github.com/catppuccin/nix/archive/main.tar.gz";
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      (import "${home-manager}/nixos")
      (import "${catppuccin}/modules/nixos")
    ];

  catppuccin.flavor = "mocha";
  catppuccin.enable = true;

  # Bootloader.
  boot.loader.grub.catppuccin.enable = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

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
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.crybot = {
    isNormalUser = true;
    description = "Marco";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  home-manager.users.crybot = { pkgs, ... }: {
    imports = [
      (import "${catppuccin}/modules/home-manager")
    ];

    catppuccin.flavor = "mocha";
    catppuccin.enable = true;
    catppuccin.pointerCursor.enable = true;

    programs = {
      kitty.enable = true;
      foot.enable = true;
      git = {
        enable = true;
        userName  = "crybot";
        userEmail = "crybot@hotmail.it";
      };
    };
    gtk.enable = true;
    gtk.catppuccin.flavor = "macchiato";
    gtk.catppuccin.enable = true;

    # The state version is required and should stay at the version you
    # originally installed.
    home.stateVersion = "24.05";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget git
    vim 
    wl-clipboard
    kitty alacritty fish 
    rofi
    waybar
    gcc clang
    python3
    firefox
    nodejs
    swaybg
    swaynotificationcenter libnotify
    brightnessctl
    networkmanagerapplet
    telegram-desktop
    cargo
    btop
    htop
    hyprshot
    google-chrome
    pavucontrol
    neofetch
    chezmoi
  ];
  # environment.extraInit = ''
  #   alias vim="nvim"
  # '';

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

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
    displayManager.gdm.enable = true;
    # videoDrivers = [ "nvidia" ];
  };
  services.libinput.enable = true;

  hardware.graphics = {
    enable = true;
  };
  hardware.graphics.extraPackages = with pkgs; [
    intel-compute-runtime
  ];

  # hardware.nvidia = {
  #   modesetting.enable = true;
  #   powerManagement.enable = false;
  #   powerManagement.finegrained = false;

  #   open = false;
  #   nvidiaSettings = true;
  #   package = config.boot.kernelPackages.nvidiaPackages.stable;
  # };

  programs.fish = {
    enable = true;
    # shellAliases = {
    #   vim = "nvim";
    # };
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
  };

  security.sudo = {
    enable = true;
    extraConfig = ''
      Defaults env_keep += "XDG_RUNTIME_DIR"
      Defaults env_keep += "WAYLAND_SOCKET"
      Defaults env_keep += "WAYLAND_DISPLAY"
    '';
  };

  fonts.packages = with pkgs; [
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
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };

  services.power-profiles-daemon.enable = true;

}

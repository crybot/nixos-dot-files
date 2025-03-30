{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  networking.hostName = "nixos-desktop"; # Define your hostname.

  # use latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  swapDevices = [{
      device = "/swapfile";
      size = 64 * 1024; # 16GB
    }];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;

    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia-container-toolkit.enable = true;

  services.displayManager = {
    sddm.enable = true;
    sddm.package = pkgs.kdePackages.sddm;
    # sddm.wayland.enable = true;
    # sddm.catppuccin.enable = false;
    sddm.catppuccin.enable = true;
    sddm.catppuccin.flavor = "mocha";
    sddm.catppuccin.fontSize = "14";
    sddm.catppuccin.font = "Noto Sans";
  };

  # catppuccin.sddm.enable = false;

}

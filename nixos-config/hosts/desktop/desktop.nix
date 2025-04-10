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

  hardware.nvidia-container-toolkit.enable = true;

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;

    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  services.xserver.videoDrivers = [ "nvidia" ];
  services.ollama = {
    enable = true;
    acceleration = "cuda";
  };

}

{ config, pkgs, lib, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  networking.hostName = "nixos-laptop"; # Define your hostname.

  # use zen kernel for better responsiveness
  boot.kernelPackages = pkgs.linuxPackages_zen;


  swapDevices = [{
      device = "/swapfile";
      size = 16 * 1024; # 16GB
    }];

  # Works for >= 8th gen Intel cpus onward
  hardware.graphics.extraPackages = with pkgs; [
    intel-compute-runtime
  ];

  services.xserver = {
    enable = true;
    # displayManager.gdm.enable = true;
  };

  # Disable to save battery (probably don't need docker here)
  virtualisation.docker.enable = lib.mkForce false;
}

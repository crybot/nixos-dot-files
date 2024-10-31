{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  networking.hostName = "nixos-laptop"; # Define your hostname.

  # Works for >=  8th gen Intel cpus onward
  hardware.graphics.extraPackages = with pkgs; [
    intel-compute-runtime
  ];

  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
  };
}

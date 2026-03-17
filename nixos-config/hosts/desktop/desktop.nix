{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  networking.hostName = "nixos-desktop"; # Define your hostname.

  # use latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  swapDevices = [
    {
      device = "/swapfile";
      size = 64 * 1024; # 16GB
    }
  ];

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
    # acceleration = "cuda";
  };

  programs.anythingllm-desktop = {
    enable = false;
  };

  services.udev.extraRules = ''
    # Disable autosuspend for AJAZZ AK820 Pro dongle (0c45:fdfd)
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="0c45", ATTR{idProduct}=="fdfd", ATTR{power/autosuspend}="-1"
  '';
}

{ config, pkgs, lib, ... }:

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
    # displayManager.gdm.enable = true;
  };

  # Disable to save battery (probably don't need docker here)
  virtualisation.docker.enable = lib.mkForce false;

  # Enable WireGuard
  # networking.wireguard.enable = false;
  # networking.wireguard.interfaces = {
  #   # "wg0" is the network interface name. You can name the interface arbitrarily.
  #   wg0 = {
  #     # Determines the IP address and subnet of the client's end of the tunnel interface.
  #     ips = [ "10.200.0.4/32" ];
  #     # listenPort = 51820; # to match firewall allowedUDPPorts (without this wg uses random port numbers)

  #     # Path to the private key file.
  #     #
  #     # Note: The private key can also be included inline via the privateKey option,
  #     # but this makes the private key world-readable; thus, using privateKeyFile is
  #     # recommended.
  #     privateKeyFile = "/home/crybot/wireguard-keys/private";
  #     # privateKey = "OGAvPvzS4obOkm4mL4d9FyLuxcqhp9iLBU3A3/ou9WA=";

  #     peers = [
  #       # For a client configuration, one peer entry for the server will suffice.

  #       {
  #         # Public key of the server (not a file path).
  #         publicKey = "AKXTpXf6/p1RvV7RcIpQxemxCB9p3mclm9//2++L+wc=";

  #         # Forward all the traffic via VPN.
  #         allowedIPs = [ "0.0.0.0/0" ];
  #         # Or forward only particular subnets
  #         #allowedIPs = [ "10.100.0.1" "91.108.12.0/22" ];

  #         # Set this to the server IP and port.
  #         endpoint = "93.39.181.138:51820"; # ToDo: route to endpoint not automatically configured https://wiki.archlinux.org/index.php/WireGuard#Loop_routing https://discourse.nixos.org/t/solved-minimal-firewall-setup-for-wireguard-client/7577

  #         # Send keepalives every 25 seconds. Important to keep NAT tables alive.
  #         persistentKeepalive = 25;
  #       }
  #     ];
  #   };
  # };
}

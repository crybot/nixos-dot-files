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

  environment.systemPackages = with pkgs; [
    wireguard-tools
  ];

  networking.firewall.enable = false; # otherwise wireguard does not work

  # No specific inbound firewall rule is typically needed for the client's WireGuard UDP port
  # if it uses an ephemeral port (default for wg-quick unless listenPort is set).
  # If a fixed listenPort is set for the client, it would need:
  # networking.firewall.allowedUDPPorts =;

  networking.wg-quick.interfaces.wg0 = { # "wg0" is an arbitrary interface name for the client
    address = [ "10.0.0.2/32" ]; # Client's VPN IP. The /24 mask helps define the VPN network view for the client.
    # The server's peer config will use 10.0.0.2/32 for this client. [13, 34]
    privateKeyFile = "/etc/nixos/wireguard_keys/client_private.key"; # Path to the client's private key [34]

    # DNS Configuration for full tunnel:
    # This routes DNS queries through the VPN to the OpenWrt server.
    # The OpenWrt server must be configured to act as a DNS resolver for VPN clients (e.g., dnsmasq listening on wg0).
    dns = [ "10.0.0.1" ]; # Use OpenWrt server's VPN IP (10.0.0.1) as the DNS resolver. [13, 35]

    peers = [{
      # AllowedIPs determines what traffic is routed through the VPN from the client side.
      # For a full tunnel (all client internet traffic via VPN):
      allowedIPs = [ "0.0.0.0/0" ]; # Routes all IPv4 traffic. For IPv6, add "::/0". [28, 30, 34]
      # For a split tunnel (e.g., only access OpenWrt LAN 192.168.4.0/24 and server's VPN IP):
      # allowedIPs = [ "192.168.4.0/24", "10.0.0.1/32" ]; [36]

      endpoint = "93.39.181.138:51820"; # Server's public IP/hostname and port [34]
      publicKey = "AKXTpXf6/p1RvV7RcIpQxemxCB9p3mclm9//2++L+wc=";

      persistentKeepalive = 25; # Sends keepalive packets every 25 seconds to maintain NAT traversal [13, 34, 37, 38, 39]
    }];

  };

  # Disable wireguard by default: enable it with systemd
  systemd.services."wg-quick-wg0" = {
    wantedBy = lib.mkForce [];
  };

  security.sudo.extraRules = [
    {
      users = [ "crybot" ]; # Your username
      commands = [
        {
          command = "/home/crybot/scripts/start-wireguard.sh";
          options = [ "NOPASSWD" ];
        }
        {
          command = "/home/crybot/scripts/stop-wireguard.sh";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

}

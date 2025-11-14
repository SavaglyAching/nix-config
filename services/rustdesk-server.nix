{ config, lib, pkgs, ... }:

{
  # RustDesk self-hosted server for remote desktop access
  # Access via Tailscale VPN only (no public firewall ports)

  services.rustdesk-server = {
    enable = true;

    # Do not open firewall - access via Tailscale only
    openFirewall = false;

    # Enable signal server (hbbs) - handles ID registration and peer discovery
    signal = {
      enable = true;
      # Point to relay server on same host (localhost)
      relayHosts = [ "127.0.0.1" ];
    };

    # Enable relay server (hbbr) - handles NAT traversal and relaying
    relay = {
      enable = true;
    };
  };

  # RustDesk uses these ports internally (accessible via Tailscale):
  # TCP: 21115 (hbbs), 21116 (hbbs/hbbr), 21117 (hbbr)
  # TCP: 21118, 21119 (WebSocket for web client - optional)
  # UDP: 21116 (NAT traversal)
}

{ config, lib, pkgs, ... }:

{
  # Network Configuration
  networking = {
    hostName = "nixos-rica";
    defaultGateway = "209.209.9.1";
    interfaces.enX0 = {
      ipv4.addresses = [{
        address = "209.209.9.14";
        prefixLength = 24;
      }];
    };
    nameservers = [ "9.9.9.9" ];

    # Firewall settings
    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 ];
      allowedUDPPorts = [ 41641 ]; # Tailscale port
      allowPing = false;
      trustedInterfaces = [ "tailscale0" ];
    };
  };
}
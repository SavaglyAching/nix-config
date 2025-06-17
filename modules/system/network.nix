{ config, lib, pkgs, ... }:

{
  networking = {
 
    nameservers = [ "100.100.100.100" "9.9.9.9" ];

    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 ]; # Allow SSH
      # allowedUDPPorts = [ 41641 ]; # Tailscale port - This is not needed as tailscale0 is a trusted interface.
      allowPing = false;
      trustedInterfaces = [ "tailscale0" ]; # Trust tailscale interface
    };
  };
}

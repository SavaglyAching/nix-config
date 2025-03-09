{ config, lib, pkgs, ... }:

{
  networking = {
    # Hostname is set in the host-specific configuration

    
    # Firewall settings
    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 ];
      allowedUDPPorts = [ 41641 ]; # Tailscale port
      allowPing = false;
      trustedInterfaces = [ "tailscale0" ];
      
    };
    

}

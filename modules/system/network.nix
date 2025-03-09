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
      
            # Extra rules for remote builder
      extraCommands = ''
        # Allow all connections from the Surface device for Nix remote building
        iptables -A INPUT -p tcp -s 192.168.2.0/24 --dport 22 -j ACCEPT
      '';
    };
    

}

{ config, lib, pkgs, ... }:

{
  # Import the Nextcloud module
  imports = [
    ../../modules/services/nextcloud.nix
  ];

  # Host-specific overrides for Nextcloud
  services.nextcloud = {
    # Use the existing hostname from network.nix
    hostName = "cloud.bloood.ca";
    
    # Additional configuration specific to nixos-rica
    config = {
      # Override or add any config values specific to this host
      trustedProxies = [ "127.0.0.1" "::1" "209.209.9.14" ];
    };
  };

  # Update the firewall to allow HTTP and HTTPS
  networking.firewall.allowedTCPPorts = [ 80 443 ];
  

  
  # Make sure we have a directory for Nextcloud data in the persist subvolume
  systemd.tmpfiles.rules = lib.mkIf config.services.nextcloud.enable [
    "d /persist/nextcloud 0750 nextcloud nextcloud -"
  ];
}

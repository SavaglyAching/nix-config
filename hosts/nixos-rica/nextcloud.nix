{ config, lib, pkgs, ... }:

{
  # Import the base Nextcloud module
  imports = [
    ../../modules/services/nextcloud.nix
  ];

  # Host-specific Nextcloud configuration
  services.nextcloud = {
    # Set the domain
    hostName = "cloud.bloood.ca";
    
    # Trusted proxies including Cloudflare's IPs
    trustedProxies = [
      "127.0.0.1" 
      "::1" 
      "209.209.9.14" # Your server IP
      # Cloudflare IP ranges (IPv4)
      "173.245.48.0/20"
      "103.21.244.0/22"
      "103.22.200.0/22"
      "103.31.4.0/22"
      "141.101.64.0/18"
      "108.162.192.0/18"
      "190.93.240.0/20"
      "188.114.96.0/20"
      "197.234.240.0/22"
      "198.41.128.0/17"
      "162.158.0.0/15"
      "104.16.0.0/13"
      "104.24.0.0/14"
      "172.64.0.0/13"
      "131.0.72.0/22"
    ];
    
    # Overrides and additional settings
    overwriteProtocol = "https"; # Force HTTPS
    overwriteHost = "cloud.bloood.ca";
    overwriteWebRoot = "/";
    
    # PHP settings specific to this host
    phpOptions = {
      "upload_max_filesize" = "16G";
      "post_max_size" = "16G";
      "memory_limit" = "512M";
    };
  };

  # Enable ACME for SSL certificate
  security.acme = {
    acceptTerms = true;
    defaults.email = "your-email@example.com"; # Change this to your email
    
    # Use DNS challenge with Cloudflare
    certs."cloud.bloood.ca" = {
      dnsProvider = "cloudflare";
      credentialsFile = "/var/lib/secrets/cloudflare-api-token";
      group = "nginx";
    };
  };
  
  # Create Cloudflare API token file (you need to manually add the token later)
  systemd.tmpfiles.rules = [
    "f /var/lib/secrets/cloudflare-api-token 0600 acme acme -"
  ];
  
  # Nginx configuration for Cloudflare
  services.nginx = {
    virtualHosts."cloud.bloood.ca" = {
      # These are set automatically by the nextcloud module
      # but we're adding some Cloudflare-specific settings
      
      # Verify Cloudflare connections
      extraConfig = ''
        # Only allow connections from Cloudflare IPs
        include ${pkgs.writeText "cloudflare-ips.conf" ''
          # IPv4
          allow 173.245.48.0/20;
          allow 103.21.244.0/22;
          allow 103.22.200.0/22;
          allow 103.31.4.0/22;
          allow 141.101.64.0/18;
          allow 108.162.192.0/18;
          allow 190.93.240.0/20;
          allow 188.114.96.0/20;
          allow 197.234.240.0/22;
          allow 198.41.128.0/17;
          allow 162.158.0.0/15;
          allow 104.16.0.0/13;
          allow 104.24.0.0/14;
          allow 172.64.0.0/13;
          allow 131.0.72.0/22;
          # IPv6 (add if you have IPv6 enabled)
          # allow 2400:cb00::/32;
          # allow 2606:4700::/32;
          # allow 2803:f800::/32;
          # allow 2405:b500::/32;
          # allow 2405:8100::/32;
          # allow 2a06:98c0::/29;
          # allow 2c0f:f248::/32;
          
          # Allow local connections for testing
          allow 127.0.0.1;
          allow ::1;
          
          # Deny everyone else
          deny all;
        ''};
        
        # Add Cloudflare headers
        set_real_ip_from 173.245.48.0/20;
        set_real_ip_from 103.21.244.0/22;
        set_real_ip_from 103.22.200.0/22;
        set_real_ip_from 103.31.4.0/22;
        set_real_ip_from 141.101.64.0/18;
        set_real_ip_from 108.162.192.0/18;
        set_real_ip_from 190.93.240.0/20;
        set_real_ip_from 188.114.96.0/20;
        set_real_ip_from 197.234.240.0/22;
        set_real_ip_from 198.41.128.0/17;
        set_real_ip_from 162.158.0.0/15;
        set_real_ip_from 104.16.0.0/13;
        set_real_ip_from 104.24.0.0/14;
        set_real_ip_from 172.64.0.0/13;
        set_real_ip_from 131.0.72.0/22;
        real_ip_header CF-Connecting-IP;
      '';
    };
  };

  # Update the firewall to allow HTTP and HTTPS for Cloudflare
  networking.firewall.allowedTCPPorts = [ 80 443 ];
}

{ config, lib, pkgs, ... }:

{
  # Nextcloud Configuration
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud28;
    hostName = "cloud.bloood.ca";
    # Use HTTPS only
    https = true;
    # Set to your timezone
    config = {
      adminpassFile = "/run/secrets/nextcloud-adminpass";
      adminuser = "admin";
      defaultPhoneRegion = "CA"; # Canada
      trustedProxies = [ "127.0.0.1" "::1" ];
      # Trust Cloudflare IPs - these are the Cloudflare IPv4 ranges
      # See: https://www.cloudflare.com/ips-v4
      extraTrustedDomains = [ 
        "cloud.bloood.ca"
      ];
      overwriteProtocol = "https";
    };
    
    # Database Configuration (PostgreSQL is recommended for performance)
    database = {
      createLocally = true;
      type = "pgsql";
    };
    
    # Redis for caching and transactional locking
    configureRedis = true;
    
    # Performance settings
    extraOptions = {
      # Memory caching
      "memcache.local" = "\\OC\\Memcache\\APCu";
      "memcache.distributed" = "\\OC\\Memcache\\Redis";
      "memcache.locking" = "\\OC\\Memcache\\Redis";
      "redis" = {
        "host" = "/run/redis/redis.sock";
        "port" = 0;
        "dbindex" = 0;
        "timeout" = 1.5;
      };
      # Upload limits
      "output_buffering" = "off";
      # Security
      "auth.bruteforce.protection.enabled" = true;
      "blacklisted.files" = [".htaccess"];
      # Background jobs
      "system" = {
        "cron_max_age" = 43200;
      };
      
      # Use a data directory outside of the BTRFS subvolume structure
      "datadirectory" = lib.mkDefault "/data/nextcloud";
    };
    
    # Optimize PHP settings for better performance
    phpOptions = {
      "opcache.interned_strings_buffer" = "16";
      "opcache.max_accelerated_files" = "10000";
      "opcache.memory_consumption" = "128";
      "opcache.save_comments" = "1";
      "opcache.revalidate_freq" = "1";
      "opcache.jit" = "1255";
      "opcache.jit_buffer_size" = "128M";
      "apc.enable_cli" = "1";
      "max_execution_time" = "300";
      "max_input_time" = "300";
      "memory_limit" = "512M";
      "upload_max_filesize" = "10G";
      "post_max_size" = "10G";
      "session.save_handler" = "redis";
      "session.save_path" = "unix:///run/redis/redis.sock";
    };
  };

  # Redis server for improved performance
  services.redis.servers.nextcloud = {
    enable = true;
    port = 0;
    unixSocket = "/run/redis/redis.sock";
    unixSocketPerm = 770;
  };

  # NGINX Configuration
  services.nginx = {
    enable = true;
    # Recommended settings
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    
    # Additional configuration for NGINX server
    virtualHosts."cloud.bloood.ca" = {
      # Let Nextcloud handle this vhost
      forceSSL = true;
      
      # Add headers for Cloudflare
      extraConfig = ''
        # Allow large uploads
        client_max_body_size 10G;
        
        # Cloudflare headers for real IP
        set_real_ip_from 103.21.244.0/22;
        set_real_ip_from 103.22.200.0/22;
        set_real_ip_from 103.31.4.0/22;
        set_real_ip_from 104.16.0.0/13;
        set_real_ip_from 104.24.0.0/14;
        set_real_ip_from 108.162.192.0/18;
        set_real_ip_from 131.0.72.0/22;
        set_real_ip_from 141.101.64.0/18;
        set_real_ip_from 162.158.0.0/15;
        set_real_ip_from 172.64.0.0/13;
        set_real_ip_from 173.245.48.0/20;
        set_real_ip_from 188.114.96.0/20;
        set_real_ip_from 190.93.240.0/20;
        set_real_ip_from 197.234.240.0/22;
        set_real_ip_from 198.41.128.0/17;
        set_real_ip_from 2400:cb00::/32;
        set_real_ip_from 2606:4700::/32;
        set_real_ip_from 2803:f800::/32;
        set_real_ip_from 2405:b500::/32;
        set_real_ip_from 2405:8100::/32;
        set_real_ip_from 2a06:98c0::/29;
        set_real_ip_from 2c0f:f248::/32;
        
        real_ip_header CF-Connecting-IP;
        
        # Security headers
        add_header Strict-Transport-Security "max-age=15768000; includeSubDomains; preload" always;
        add_header X-Content-Type-Options "nosniff" always;
        add_header X-Frame-Options "SAMEORIGIN" always;
        add_header X-XSS-Protection "1; mode=block" always;
        add_header Referrer-Policy "no-referrer-when-downgrade" always;
        
        # OCSP stapling
        ssl_stapling on;
        ssl_stapling_verify on;
      '';
    };
  };

  # Let's Encrypt SSL certificates using DNS validation for Cloudflare
  security.acme = {
    acceptTerms = true;
    defaults.email = "admin@bloood.ca"; # Replace with your email if needed
    
    certs."cloud.bloood.ca" = {
      dnsProvider = "cloudflare";
      credentialsFile = "/run/secrets/cloudflare-credentials";
      group = "nginx";
    };
  };

  # Create secrets
  systemd.services.create-nextcloud-secrets = {
    description = "Create Nextcloud secrets";
    wantedBy = [ "multi-user.target" ];
    after = [ "local-fs.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      mkdir -p /run/secrets
      
      # Create admin password if it doesn't exist
      if [ ! -f /run/secrets/nextcloud-adminpass ]; then
        echo "Creating Nextcloud admin password"
        # Generate a random password
        tr -dc 'A-Za-z0-9!#$%&()*+,-./:;<=>?@[\]^_{|}~' < /dev/urandom | head -c 32 > /run/secrets/nextcloud-adminpass
        chmod 400 /run/secrets/nextcloud-adminpass
      fi
      
      # Create Cloudflare credentials template if it doesn't exist
      if [ ! -f /run/secrets/cloudflare-credentials ]; then
        echo "Creating Cloudflare credentials template"
        cat > /run/secrets/cloudflare-credentials << 'EOF'
# Cloudflare credentials for DNS validation
# Replace with your actual API token
dns_cloudflare_api_token = your_cloudflare_api_token
EOF
        chmod 400 /run/secrets/cloudflare-credentials
        echo "⚠️ IMPORTANT: Edit /run/secrets/cloudflare-credentials with your actual Cloudflare API token"
      fi
    '';
  };

  # Automatic optimizations
  services.nextcloud-cron = {
    enable = true;
    user = "nextcloud";
  };

  # System tuning for Nextcloud
  boot.kernel.sysctl = {
    "fs.inotify.max_user_watches" = 524288;
  };

  # Backup configuration
  services.postgresqlBackup = {
    enable = true;
    databases = [ "nextcloud" ];
  };

  # Custom systemd service for periodic maintenance tasks
  systemd.services.nextcloud-maintenance = {
    description = "Nextcloud periodic maintenance tasks";
    startAt = "weekly";
    serviceConfig = {
      Type = "oneshot";
      User = "nextcloud";
      ExecStart = ''
        ${pkgs.nextcloud28}/bin/nextcloud-occ db:add-missing-indices
        ${pkgs.nextcloud28}/bin/nextcloud-occ db:convert-filecache-bigint
        ${pkgs.nextcloud28}/bin/nextcloud-occ files:scan --all
      '';
    };
  };
  
  # Borg backup for Nextcloud data
  services.borgbackup.jobs.nextcloudBackup = {
    paths = [
      "/data/nextcloud"
      "/var/backup/postgresql"
    ];
    repo = "/mnt/backup/nextcloud";
    encryption = {
      mode = "repokey";
      passCommand = "cat /run/secrets/borg-passphrase";
    };
    compression = "auto,lzma";
    startAt = "daily";
    environment = { BORG_RELOCATED_REPO_ACCESS_IS_OK = "yes"; };
    prune.keep = {
      within = "1d"; # Keep all archives within 1 day
      daily = 7;     # Keep 7 daily archives
      weekly = 4;    # Keep 4 weekly archives
      monthly = 6;   # Keep 6 monthly archives
    };
  };
  
  # Create Borg passphrase
  systemd.services.create-borg-secrets = {
    description = "Create Borg backup secrets";
    wantedBy = [ "multi-user.target" ];
    after = [ "local-fs.target" ];
    before = [ "borgbackup-job-nextcloudBackup.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      mkdir -p /run/secrets
      
      # Create Borg passphrase if it doesn't exist
      if [ ! -f /run/secrets/borg-passphrase ]; then
        echo "Creating Borg backup passphrase"
        tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 32 > /run/secrets/borg-passphrase
        chmod 400 /run/secrets/borg-passphrase
        
        # Initialize Borg repository if it doesn't exist
        mkdir -p /mnt/backup/nextcloud
        BORG_PASSPHRASE=$(cat /run/secrets/borg-passphrase) ${pkgs.borgbackup}/bin/borg init --encryption=repokey /mnt/backup/nextcloud
      fi
    '';
  };
}

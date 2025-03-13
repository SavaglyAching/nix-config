{ config, lib, pkgs, ... }:

{
  # Enable PostgreSQL for Nextcloud
  services.postgresql = {
    enable = true;
    ensureDatabases = [ "nextcloud" ];
    ensureUsers = [
      { 
        name = "nextcloud";
        ensureDBOwnership = true;  # This ensures the user has the necessary permissions
      }
    ];
  };

  # Redis server for improved performance
  services.redis.servers.nextcloud = {
    enable = true;
    port = 0;
    unixSocket = "/run/redis/redis.sock";
    unixSocketPerm = 770;
    user = lib.mkForce "nextcloud"; # Use nextcloud user to avoid conflicts
    settings = {
      # Ensure directories exist
      dir = "/var/lib/redis-nextcloud";
      # Extra reliability settings
      appendonly = "yes";
      appendfsync = "everysec";
    };
  };
  
  # Ensure Redis socket directory exists with proper permissions
  systemd.tmpfiles.rules = [
    "d /run/redis 0770 redis redis -"
  ];

  # Nextcloud Configuration
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud29;  # Updated to latest version
    hostName = "cloud.bloood.ca";
    https = true;
    
    # Set data directory location
    datadir = "/persist/nextcloud";
    
    # Database and admin settings
    config = {
      adminpassFile = "/run/secrets/nextcloud-adminpass";
      adminuser = "admin";
      dbtype = "pgsql";
      dbname = "nextcloud";
      dbuser = "nextcloud";
      dbhost = "/run/postgresql"; # for the socket directory
      defaultPhoneRegion = "CA"; # Canada
      trustedProxies = [ "127.0.0.1" "::1" ];
      extraTrustedDomains = [ "cloud.bloood.ca" ];
      overwriteProtocol = "https";
    };
    
    # Auto-update apps and configure Redis
    autoUpdateApps.enable = true;
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
    };
    
    # Optimize PHP settings for better performance
    phpOptions = {
      "opcache.interned_strings_buffer" = lib.mkForce "16";
      "opcache.max_accelerated_files" = lib.mkForce "10000";
      "opcache.memory_consumption" = lib.mkForce "128";
      "opcache.save_comments" = lib.mkForce "1";
      "opcache.revalidate_freq" = lib.mkForce "1";
      "opcache.jit" = lib.mkForce "1255";
      "opcache.jit_buffer_size" = lib.mkForce "128M";
      "apc.enable_cli" = lib.mkForce "1";
      "max_execution_time" = lib.mkForce "300";
      "max_input_time" = lib.mkForce "300";
      "memory_limit" = lib.mkForce "512M";
      "upload_max_filesize" = lib.mkForce "10G";
      "post_max_size" = lib.mkForce "10G";
      "session.save_handler" = lib.mkForce "redis";
      "session.save_path" = lib.mkForce "unix:///run/redis/redis.sock";
    };
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
      # Use certificates from ACME
      useACMEHost = "cloud.bloood.ca";
      
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
      reloadServices = [ "nginx" ];
    };
  };

  # Create secrets with proper permissions - run before other services
  systemd.services.create-nextcloud-secrets = {
    description = "Create Nextcloud secrets";
    wantedBy = [ "multi-user.target" ];
    before = [ "acme-cloud.bloood.ca.service" "nextcloud-setup.service" "redis-nextcloud.service" ];
    after = [ "local-fs.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      mkdir -p /run/secrets
      mkdir -p /run/redis
      
      # Create admin password if it doesn't exist
      if [ ! -f /run/secrets/nextcloud-adminpass ]; then
        echo "Creating Nextcloud admin password"
        # Generate a random password
        tr -dc 'A-Za-z0-9!#$%&()*+,-./:;<=>?@[\]^_{|}~' < /dev/urandom | head -c 32 > /run/secrets/nextcloud-adminpass
      fi
      
      # Ensure Redis socket directory exists with proper permissions
      chown redis:redis /run/redis
      chmod 770 /run/redis
      
      # Fix permissions - ensure nextcloud user can read the password file
      chown nextcloud:nextcloud /run/secrets/nextcloud-adminpass
      chmod 400 /run/secrets/nextcloud-adminpass
      
      # Create Cloudflare credentials in the correct format
      if [ ! -f /run/secrets/cloudflare-credentials ]; then
        echo "Creating Cloudflare credentials template"
        cat > /run/secrets/cloudflare-credentials << 'EOF'
# Cloudflare credentials for DNS validation
# You need EITHER:
# Option 1: API Token (recommended)
CLOUDFLARE_DNS_API_TOKEN=your_cloudflare_api_token

# OR Option 2: Global API Key
# CLOUDFLARE_EMAIL=your_cloudflare_email@example.com
# CLOUDFLARE_API_KEY=your_global_api_key
EOF
        chmod 400 /run/secrets/cloudflare-credentials
        echo "⚠️ IMPORTANT: Edit /run/secrets/cloudflare-credentials with your actual Cloudflare API token"
      fi
    '';
  };

  # Automatic cron job
  # Let the Nextcloud service handle cron jobs
  services.nextcloud.caching.apcu = true;

  # Add dependencies between services
  systemd.services.redis-nextcloud = {
    after = [ "create-nextcloud-secrets.service" ];
    requires = [ "create-nextcloud-secrets.service" ];
  };
  
  systemd.services.nextcloud-setup = {
    after = [ "create-nextcloud-secrets.service" ];
    requires = [ "create-nextcloud-secrets.service" ];
  };
  
  # Configure users and groups
  # Make sure nextcloud user is in redis group to access the socket
  users.groups.redis.members = [ "nextcloud" ];
  
  # System tuning for Nextcloud
  boot.kernel.sysctl = {
    "fs.inotify.max_user_watches" = 524288;
  };

  # Custom systemd service for periodic maintenance tasks
  systemd.services.nextcloud-maintenance = {
    description = "Nextcloud periodic maintenance tasks";
    startAt = "weekly";
    serviceConfig = {
      Type = "oneshot";
      User = "nextcloud";
      ExecStart = ''
        ${pkgs.nextcloud29}/bin/nextcloud-occ db:add-missing-indices
        ${pkgs.nextcloud29}/bin/nextcloud-occ db:convert-filecache-bigint
        ${pkgs.nextcloud29}/bin/nextcloud-occ files:scan --all
      '';
    };
  };
}

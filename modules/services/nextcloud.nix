{ config, lib, pkgs, ... }:

{
  # Basic Nextcloud configuration
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud28;
    
    # These will be overridden in host-specific config
    hostName = "localhost";
    https = true;
    
    # Database configuration
    config = {
      dbtype = "pgsql";
      adminpassFile = "/var/lib/nextcloud-admin-pass";
      dbuser = "nextcloud";
      dbhost = "/run/postgresql";
      dbpassFile = "/var/lib/nextcloud-db-pass";
      defaultPhoneRegion = "CA"; # Canada
      
      # Performance tuning
      memoryLimit = 512;
      caching = {
        apcu = true;
        redis = true;
        memcached = false;
      };
    };
    
    # Storage path
    datadir = "/persist/nextcloud";
    
    # Automatic updates
    autoUpdateApps = {
      enable = true;
      startAt = "05:00:00";
    };
    
    # Nginx configuration
    configureRedis = true;
  };
  
  # PostgreSQL configuration
  services.postgresql = {
    enable = true;
    ensureDatabases = [ "nextcloud" ];
    ensureUsers = [
      {
        name = "nextcloud";
        ensurePermissions = {
          "DATABASE nextcloud" = "ALL PRIVILEGES";
        };
      }
    ];
  };
  
  # Redis for caching
  services.redis.servers.nextcloud = {
    enable = true;
    port = 6379;
    bind = "127.0.0.1";
  };
  
  # Setup systemd services to generate initial password files if they don't exist
  systemd.services.nextcloud-setup = {
    description = "Set up nextcloud password files";
    wantedBy = [ "multi-user.target" ];
    before = [ "phpfpm-nextcloud.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      if [ ! -f /var/lib/nextcloud-admin-pass ]; then
        tr -dc A-Za-z0-9 < /dev/urandom | head -c 32 > /var/lib/nextcloud-admin-pass
        chmod 600 /var/lib/nextcloud-admin-pass
        echo "Generated admin password"
      fi
      
      if [ ! -f /var/lib/nextcloud-db-pass ]; then
        tr -dc A-Za-z0-9 < /dev/urandom | head -c 32 > /var/lib/nextcloud-db-pass
        chmod 600 /var/lib/nextcloud-db-pass
        echo "Generated database password"
      fi
    '';
  };
  
  # Generate persistent directory for Nextcloud data
  systemd.tmpfiles.rules = [
    "d /persist/nextcloud 0750 nextcloud nextcloud -"
    "d /var/lib/nextcloud-passwords 0700 nextcloud nextcloud -"
  ];
}

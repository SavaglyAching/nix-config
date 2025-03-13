{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    # System modules
    ../../modules/system/boot.nix
    ../../modules/system/network.nix
    ../../modules/system/users.nix
    ../../modules/system/shell.nix
    ../../modules/system/packages.nix
    ../../modules/system/nix.nix
    
    # BTRFS for snapshots and better storage management
    ../../modules/system/btrfs.nix
    
    # Services
    ../../modules/services/ssh.nix
    ../../modules/services/tailscale.nix
    ../../modules/services/docker.nix
    ../../modules/services/nextcloud.nix
  ];

  # Host-specific network configuration
  networking.hostName = "nixos-cloud";
  
  # Additional network configuration
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 443 22 ]; # HTTP, HTTPS, SSH
    
    # Allow Tailscale network
    trustedInterfaces = [ "tailscale0" ];
    
    # Allow established connections
    allowedUDPPorts = [ 41641 ]; # Tailscale UDP port
  };

  # Set your timezone
  time.timeZone = "America/Moncton";
  
  # Auto-upgrade the system
  system.autoUpgrade = {
    enable = true;
    allowReboot = true;
    dates = "04:00";
    randomizedDelaySec = "45min";
  };
  
  # Automatic garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
  
  # Enable Swap (important for performance)
  swapDevices = [
    {
      device = "/var/swap";
      size = 4096; # 4GB of swap, adjust as needed
    }
  ];
  
  # SSD optimizations if applicable
  services.fstrim.enable = true;
  
  # System backup settings
  services.borgbackup.jobs.nextcloudBackup = {
    paths = [
      "/var/lib/nextcloud"
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
  
  # Add Borg passphrase to secrets
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
  
  # Create mountpoint for backups
  systemd.tmpfiles.rules = [
    "d /mnt/backup 0750 root root -"
  ];
  
  # System state version - do not change after initial setup
  system.stateVersion = "24.11";
}

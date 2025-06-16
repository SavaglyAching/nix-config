# hosts/nixos-surface/default.nix
{ config, lib, pkgs, nix-surface, ... }:

{
  imports = [
    # System modules (assuming these paths are correct relative to your flake root)
    ../../modules/system/boot.nix
    ../../modules/system/network.nix
    ../../modules/system/users.nix
    ../../modules/system/shell.nix
    ../../modules/system/packages.nix
    ../../modules/system/nix.nix
    ../../modules/system/remote-builder.nix
    
    ## Desktop environment (choose one)

    ../../modules/desktop/gnome.nix # Make sure this path points to your KDE Plasma module
    
    # Services
    ../../modules/services/ssh.nix
    ../../modules/services/tailscale.nix
  ];

  # Use the linux-surface kernel for optimal hardware support
  boot.kernelPackages = pkgs.linuxPackages_surface;

  # Host-specific network configuration
  networking.hostName = "nixos-surface";

  # Network configuration using iwd backend
  # This is a cleaner way to enable NetworkManager with iwd
  services.NetworkManager.enable = true;
  services.iwd.enable = true;
  networking.wireless.iwd.enable = true; # Explicitly enabling iwd can help in some setups

  # Add user to required groups for a typical desktop
  users.users.ham.extraGroups = [ 
    "networkmanager" 
    "wheel" # For administrative tasks with sudo
    "input"
    "video"
    "dialout"
  ];

  # Enable remote builder with improved security
  nix = {
    settings = {
      # Restrict trusted-users for better security.
      # Your user 'ham' should use sudo for privileged operations.
      trusted-users = [ "root" ];
      builders-use-substitutes = true;
    };
    distributedBuilds = true;
    buildMachines = [
      {
        hostName = "eu.nixbuild.net";
        system = "x86_64-linux";
        maxJobs = 100;
        supportedFeatures = [ "benchmark" "big-parallel" ];
        # It's best practice to handle SSH user and key via ~/.ssh/config
      }
    ];
    # Enable experimental features for flakes
    settings.experimental-features = [ "nix-command" "flakes" ];
  };
  
  # Locale and Timezone
  i18n.defaultLocale = "en_CA.UTF-8";
  time.timeZone = "America/Moncton";

  # Enable hardware features. nixos-hardware module handles most of this,
  # but explicit enabling is fine.
  hardware.graphics.enable = true;
  hardware.bluetooth.enable = true;
  hardware.enableRedistributableFirmware = true;
  
  # Enable Waydroid for Android app support
  virtualisation.waydroid.enable = true;

  # System state version
  system.stateVersion = "24.11";
}
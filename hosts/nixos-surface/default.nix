# hosts/nixos-surface/default.nix
{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    # System modules (ensure these paths are correct)
    ../../modules/system/boot.nix
    ../../modules/system/network.nix
    ../../modules/system/users.nix
    ../../modules/system/shell.nix
    ../../modules/system/packages.nix
    ../../modules/system/nix.nix
    ../../modules/system/remote-builder.nix
    

    ../../modules/desktop/gnome.nix
    
    # Services
    ../../modules/services/ssh.nix
    ../../modules/services/tailscale.nix
  ];

  # REMOVED: This is now handled by nixos-hardware and must be removed.
  # boot.kernelPackages = pkgs.linuxPackages_surface;

  # Host-specific network configuration
  networking.hostName = "nixos-surface";

  # Network configuration using iwd backend
  networking.networkmanager.enable = true;
   
 

  # Add user to required groups
  users.users.ham.extraGroups = [ 
    "networkmanager" 
    "wheel"    # For admin tasks with sudo
    "input"
    "video"
    "dialout"
    "surface-control" # To use surface-control tool without sudo
  ];

  # Explicitly enable surface-control tools (good practice)
 
  
  # Remote builder with improved security
  nix = {
    settings = {
      trusted-users = [ "root" ];
      builders-use-substitutes = true;
    };
    distributedBuilds = true;
    buildMachines = [
      {
        hostName = "100.71.107.77";
        system = "x86_64-linux";
        maxJobs = 100;
        supportedFeatures = [ "benchmark" "big-parallel" ];
      }
    ];
    settings.experimental-features = [ "nix-command" "flakes" ];
  };
  
  # Locale and Timezone
  i18n.defaultLocale = "en_CA.UTF-8";
  time.timeZone = "America/Moncton";

  # Hardware features (nixos-hardware handles most of this)
  hardware.graphics.enable = true;
  hardware.bluetooth.enable = true;
  hardware.enableRedistributableFirmware = true;
  hardware.microsoft-surface.kernelVersion = "stable";
  
  # Enable Waydroid for Android app support
  virtualisation.waydroid.enable = true;

  # System state version

  system.stateVersion = "24.11";
}

# hosts/nixos-surface/default.nix
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
    ../../modules/system/remote-builder.nix
    
    # Use KDE Plasma
    ../../modules/desktop/kde.nix
    
    # Services
    ../../modules/services/ssh.nix
    ../../modules/services/tailscale.nix
  ];

  # Host-specific network configuration
  networking.hostName = "nixos-surface";

  # Surface-specific hardware support
  hardware.firmware = with pkgs; [ linux-firmware ];
  
  # Network configuration
  networking.networkmanager = {
    enable = true;
    wifi.backend = "iwd";  # Better WiFi performance
  };
  
  # Better WiFi for Surface
  networking.wireless.iwd.enable = true;
  networking.interfaces.wlp0s20f3.useDHCP = true;

  # Add user to required groups
  users.users.ham.extraGroups = [ 
    "networkmanager" 
    "input"
    "video"
    "dialout"  # For serial devices
  ];

  # Screen rotation (handled by nixos-hardware or KDE)
  # hardware.sensor.iio.enable = true; # Keep commented for now, may be auto-enabled
  
  # Enable remote builder
  nix = {
    settings.trusted-users = [ "ham" "root" ];
    distributedBuilds = true;
    # settings.builders = [ "ssh://eu.nixbuild.net x86_64-linux" ]; # Use buildMachines instead
    buildMachines = [
      {
        hostName = "eu.nixbuild.net";
        system = "x86_64-linux";
        maxJobs = 100; # As per nixbuild.net docs
        supportedFeatures = [ "benchmark" "big-parallel" ]; # As per nixbuild.net docs
        sshUser = "ham"; # Assuming you connect as 'ham' based on the failed build log
        sshKey = "/root/.ssh/my-nixbuild-key"; # Updated path
      }
    ];
  };

  # Locale settings
  i18n = {
    defaultLocale = "en_CA.UTF-8";
    supportedLocales = [ "en_CA.UTF-8/UTF-8" ];
  };

  # Enable Wayland session for KDE's display manager (SDDM)
  services.displayManager.sddm.wayland.enable = true;


  # Surface hardware support
  hardware.graphics.enable = true;
  hardware.enableRedistributableFirmware = true;
  hardware.bluetooth.enable = true;
  
  # Enable experimental features for flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # Time zone
  time.timeZone = "America/Moncton";
  
  # System state version
  system.stateVersion = "24.11";
}

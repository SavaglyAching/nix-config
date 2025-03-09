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
    # Temporarily commenting out remote-builder to isolate issues
    ../../modules/system/remote-builder.nix
    
    # Desktop environment - KDE works well with touchscreens
    ../../modules/desktop/kde.nix
    
    # Services
    ../../modules/services/ssh.nix
    ../../modules/services/tailscale.nix
  ];

  # Host-specific network configuration
  networking.hostName = "nixos-surface";

  # Temporarily disable waydroid to isolate issues
  virtualisation.waydroid.enable = true;
  # Surface-specific network configuration
  hardware.firmware = with pkgs; [ linux-firmware ];  # Ensure all firmware is available
  environment.systemPackages = with pkgs; [ maliit-keyboard maliit-framework ]; 
  
  # Ensure NetworkManager is configured for Surface hardware
  networking.networkmanager = {
    enable = true;
    wifi.backend = "iwd";
  };
  
  # Enable iwd for better WiFi
  networking.wireless.iwd.enable = true;
  
  # Fallback network configuration with correct interface name
  networking.interfaces.wlp0s20f3 = {
    useDHCP = true;
  };

  # Add user to networkmanager group
  users.users.ham.extraGroups = [ "networkmanager" ];

  # Surface-specific configurations
  # The nixos-hardware module already includes the necessary configurations
  # for Surface devices, so we don't need to explicitly enable features here.
  # If specific options are needed, they can be added after consulting the
  # nixos-hardware documentation.
  
  # Enable remote builder
  nix = {
    settings.trusted-users = [ "ham" "root" ];
    # Ensure distributed builds are enabled on the client
    distributedBuilds = true;
    # Additional build machines can be configured here if needed
  };

  # Enable libinput for better touchscreen and touchpad support
  i18n = {
    defaultLocale = "en_CA.UTF-8";
    supportedLocales = [ "en_CA.UTF-8/UTF-8" ];
  };

  # Ensure Tailscale is enabled for remote builder connection
  services.tailscale.enable = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # Enable firmware for better hardware support
  hardware.enableRedistributableFirmware = true;

  # Remote builder configuration using Tailscale
  time.timeZone = "America/Moncton";
  
  # System state version - do not change after initial setup
  system.stateVersion = "24.11";
}

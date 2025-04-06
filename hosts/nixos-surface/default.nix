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
    
    # Desktop environment - KDE works well with touchscreens
    ../../modules/desktop/kde.nix
    
    # Import the updated virtual keyboard module
    ../../modules/desktop/virtual-keyboard.nix
    
    # Services
    ../../modules/services/ssh.nix
    ../../modules/services/tailscale.nix
  ];

  # Host-specific network configuration
  networking.hostName = "nixos-surface";

  # Surface-specific configurations
  virtualisation.waydroid.enable = true;
  hardware.firmware = with pkgs; [ linux-firmware ];  # Ensure all firmware is available
  
  # Ensure NetworkManager is configured for Surface hardware
  networking.networkmanager = {
    enable = true;
    wifi.backend = "iwd";  # Use iwd backend for better WiFi performance
  };
  
  # Enable iwd for better WiFi
  networking.wireless.iwd.enable = true;
  
  # Fallback network configuration with correct interface name
  networking.interfaces.wlp0s20f3 = {
    useDHCP = true;
  };

  # Add user to input and touchscreen related groups
  users.users.ham.extraGroups = [ 
    "networkmanager" 
    "input"        # For input devices access
    "video"        # For graphics/display access
  ];

  # Surface-specific tablet and pen support
  services.xserver.wacom.enable = true;
  

  # Locale settings
  i18n = {
    defaultLocale = "en_CA.UTF-8";
    supportedLocales = [ "en_CA.UTF-8/UTF-8" ];
  };

  # Additional touch-optimized packages
  environment.systemPackages = with pkgs; [
    # Add gesture support tools
    libinput
    libinput-gestures
    touchegg
    
    # Screen rotation helper
    iio-sensor-proxy
  ];

  # Enable automatic screen rotation
  hardware.sensor.iio.enable = true;
  
  # Ensure proper graphics support
  hardware.graphics.enable = true;
  hardware.enableRedistributableFirmware = true;

  # Ensure Tailscale is enabled for remote builder connection
  services.tailscale.enable = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # Time zone
  time.timeZone = "America/Moncton";
  
  # System state version - do not change after initial setup
  system.stateVersion = "24.11";
}

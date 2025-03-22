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
  services.fcitx5.enable = true;
  # Enable libinput for better touchscreen and touchpad support
  i18n = {
    defaultLocale = "en_CA.UTF-8";
    supportedLocales = [ "en_CA.UTF-8/UTF-8" ];
  };


  # Add this to your nixos-surface/default.nix file

# Virtual keyboard configuration
i18n.inputMethod = {
  type = "fcitx5";
  enable = true;
  fcitx5.addons = with pkgs; [
    fcitx5-gtk
    fcitx5-configtool
    fcitx5-with-addons
  ];
};

# Ensure the maliit framework is properly configured
services.libinput.enable = true;

# Add more comprehensive touch-related packages
environment.systemPackages = with pkgs; [
  maliit-keyboard
  maliit-framework
  onboard      # Alternative on-screen keyboard
  fcitx5-configtool
  wev          # Tool to debug input events
];

# Enable gesture support
services.desktopManager.plasma6.enable = true;
services.displayManager.sddm.settings = {
  General = {
    InputMethod = "qtvirtualkeyboard";
  };
};

# Required for proper touch input
hardware.graphics.enable = true;


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

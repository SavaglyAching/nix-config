# hosts/asahi/default.nix
{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./disko.nix
    ../../common.nix

    # Host-specific modules
    ../../system/wifi.nix
    ../../desktop/niri.nix
    ../../portable/default.nix
  ] ++ (lib.optional (builtins.pathExists ./hardware-configuration.nix) ./hardware-configuration.nix);

  # Host-specific network configuration
  networking.hostName = "asahi";

  # Set platform for aarch64-linux
  nixpkgs.hostPlatform = "aarch64-linux";

  # Network configuration using NetworkManager
  # DNS handled by systemd-resolved (configured in system/network.nix)
  networking.networkmanager = {
    enable = true;
    dns = "systemd-resolved";
  };

  # Asahi-specific hardware configuration
  hardware.asahi = {
    peripheralFirmwareDirectory = ./firmware;
    extractPeripheralFirmware = false;  # We manage firmware manually
  };

  # Boot configuration
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;  # Required for Asahi

  # Hardware features
  hardware.graphics.enable = true;
  hardware.bluetooth.enable = true;
  hardware.enableRedistributableFirmware = true;

  # PipeWire audio
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # Add user to required groups
  users.users.ham.extraGroups = [
    "networkmanager"
    "wheel"
    "input"
    "video"
  ];

  # Locale and Timezone
  i18n.defaultLocale = "en_CA.UTF-8";
  time.timeZone = "America/Moncton";

  # System state version
  system.stateVersion = "24.11";
}

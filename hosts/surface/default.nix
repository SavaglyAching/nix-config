# hosts/surface/default.nix
{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ../../common.nix

    # Host-specific modules
    ../../system/remote-builder.nix
    ../../system/wifi.nix
    ../../desktop/gnome.nix
    # ../../desktop/niri.nix  # Uncomment to try the Niri Wayland session (touch-friendly scrollable tiling)

    # ../../system/shell.nix
  ] ++ (lib.optional (builtins.pathExists ./hardware-configuration.nix) ./hardware-configuration.nix);


  # REMOVED: This is now handled by nixos-hardware and must be removed.
  # boot.kernelPackages = pkgs.linuxPackages_surface;

  # Host-specific network configuration
  networking.hostName = "surface";

  # Network configuration using NetworkManager
  # DNS handled by systemd-resolved (configured in system/network.nix)
  networking.networkmanager = {
    enable = true;
    dns = "systemd-resolved";
  };

  # Add user to required groups
  users.users.ham.extraGroups = [
    "networkmanager"
    "wheel" # For admin tasks with sudo
    "input"
    "video"
    "dialout"
  ];

  # Surface-specific packages
  environment.systemPackages = with pkgs; [
    surface-control  # Performance mode control for Surface devices
  ];

  # Enable Surface-specific hardware features
  services.iptsd.enable = true;  # Intel Precise Touch & Stylus daemon

  # Remote builder with improved security
  nix = {
    settings = {
      trusted-users = [ "root" "ham" ];
      builders-use-substitutes = true;
      trusted-substituters = [ "ssh://mini" ];
    };
    distributedBuilds = true;
    buildMachines = [{
      hostName = "100.71.107.77";
      system = "x86_64-linux";
      maxJobs = 100;
      supportedFeatures = [ "benchmark" "big-parallel" ];
    }];
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

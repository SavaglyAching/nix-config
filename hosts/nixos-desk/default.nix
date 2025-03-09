{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/boot.nix
    ../../modules/system/network.nix
    ../../modules/system/users.nix
    ../../modules/system/shell.nix
    ../../modules/system/packages.nix
    ../../modules/system/nix.nix
    ../../modules/system/btrfs.nix
    ../../modules/system/remote-builder.nix
    ../../modules/desktop/kde.nix
    ../../modules/services/ssh.nix
    ../../modules/services/tailscale.nix
    ../../modules/services/ollama.nix
    ../../modules/services/docker.nix
  ];

  # Host-specific network configuration
  networking.hostName = "nixos-desk";

  # Remote builder configuration
  services.remote-builder = {
    enable = true;
    isBuilder = true;
    builderUser = "ham";
  };
  
  time.timeZone = "America/Moncton";
  # Ensure ham is a trusted user for Nix operations
  nix.settings.trusted-users = [ "ham" "root" ];
  networking.networkmanager.enable = true;
  # System state version
  system.stateVersion = "24.11";
}

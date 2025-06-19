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
    ../../modules/gaming/gaming.nix
    ../../modules/system/sops.nix
  ];
  # Host-specific network configuration
  networking.hostName = "nixos-desk";
            
  hardware.bluetooth.enable = true;
  time.timeZone = "America/Moncton";
  # Ensure ham is a trusted user for Nix operations, which is required for remote building.
  nix.settings.trusted-users = [ "ham" "root" ];
  networking.networkmanager.enable = true;
  # System state version
  system.stateVersion = "24.11";
}

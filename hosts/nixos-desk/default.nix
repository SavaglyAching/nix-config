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

  # Firewall configuration for remote builder
  networking.firewall = {
    enable = true;
    # Allow all connections from the Surface device for Nix remote building
    extraCommands = ''
      iptables -A INPUT -p tcp -s 192.168.2.0/24 --dport 22 -j ACCEPT
    '';
  };

  time.timeZone = "America/Moncton";
  # Ensure ham is a trusted user for Nix operations
  nix.settings.trusted-users = [ "ham" "root" ];
  networking.networkmanager.enable = true;
  # System state version
  system.stateVersion = "24.11";
}

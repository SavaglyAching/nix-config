{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./boot.nix
    ./network.nix
    ./samba.nix
    ./docker.nix

    ./nextcloud.nix

    ../../modules/desktop/kde.nix
    
    # System modules
    ../../modules/system/users.nix
    ../../modules/system/shell.nix
    ../../modules/system/packages.nix
    ../../modules/system/nix.nix
    ../../modules/system/btrfs.nix
    
    # Services
    ../../modules/services/ssh.nix
    ../../modules/services/tailscale.nix
    ../../modules/services/remote-desktop.nix
  ];

  # System state version - do not change after initial setup
  system.stateVersion = "24.11";
}

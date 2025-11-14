{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../common.nix
    
    # Host-specific local modules
    ./boot.nix
    ./network.nix
    # ./docker.nix
    #./caddy.nix
    #./nextcloud.nix

    # Additional system modules
    ../../system/btrfs.nix

    # Host-specific services
    # ../../services/samba-server.nix
    # ../../services/remote-desktop.nix
    
    # ../../desktop/kde.nix
  ];



  environment.systemPackages = with pkgs; [ borgbackup ];

  # System state version - do not change after initial setup
  system.stateVersion = "24.11";
}

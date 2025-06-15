{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./boot.nix
    ./network.nix
    ./samba.nix
    ./docker.nix
    #./caddy.nix

    #./nextcloud.nix

    # ../../modules/desktop/kde.nix
    
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

  # Configure nixos-desk as a remote builder
  nix.buildMachines = [
    {
      hostName = "nixos-desk";
      sshUser = "ham";
      sshKey = "/home/ham/.ssh/id_ed25519";
      maxJobs = 8;
      speedFactor = 2;
      supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" ];
      mandatoryFeatures = [ ];
    }
  ];

  environment.systemPackages = with pkgs; [
   borgbackup
  ];

  # System state version - do not change after initial setup
  system.stateVersion = "24.11";
}

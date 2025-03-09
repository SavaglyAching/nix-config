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
    
    # Uncomment the modules you want to use
    # ../../modules/system/btrfs.nix
    
    # Desktop environment (choose one)
    # ../../modules/desktop/kde.nix
    
    # Services (uncomment as needed)
    # ../../modules/services/ssh.nix
    # ../../modules/services/tailscale.nix
    # ../../modules/services/ollama.nix
    # ../../modules/services/docker.nix
  ];

  # Host-specific network configuration
  networking.hostName = "hostname"; # Replace with actual hostname

  # System state version - do not change after initial setup
  system.stateVersion = "24.11";
  
  # Add any host-specific configuration below
}
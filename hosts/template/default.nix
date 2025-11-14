{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../common.nix
    
    # Additional system modules
    ../../system/shell.nix

    # Uncomment the modules you want to use
    # ../../system/btrfs.nix

    # Desktop environment (choose one)
    # ../../desktop/kde.nix

    # Services (uncomment as needed)
    # ../../services/ollama.nix
    # ../../services/docker.nix
  ];

  # Host-specific network configuration
  networking.hostName = "hostname"; # Replace with actual hostname

  # System state version - do not change after initial setup
  system.stateVersion = "24.11";

  # Add any host-specific configuration below
}

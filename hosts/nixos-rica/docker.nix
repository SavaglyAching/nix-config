{ config, lib, pkgs, ... }:

{
  # Import the base Docker module
  imports = [
    ../../modules/services/docker.nix
  ];

  # Host-specific Docker configuration
  virtualisation.docker = {
    storageDriver = "btrfs";
  };
}
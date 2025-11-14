{ config, lib, pkgs, ... }:

{
  # Import the base Docker module
  imports = [ ../../services/docker.nix ];

  # Host-specific Docker configuration
  virtualisation.docker = { storageDriver = "btrfs"; };
}

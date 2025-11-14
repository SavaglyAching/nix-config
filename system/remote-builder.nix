{ config, lib, pkgs, ... }:

{
  # Enable this host to be used as a remote builder by other machines.
  # This allows the machine to accept build tasks from other NixOS systems
  # on the network, provided they have the correct SSH access.
  nix.distributedBuilds = true;

  # The builder user must be trusted for Nix operations.
  # This is configured in the host-specific file (e.g., hosts/nixos-desk/default.nix)
  # to ensure it includes all necessary users for that host.
  # Example: nix.settings.trusted-users = [ "root" "ham" ];

  # The SSH service must be enabled for clients to connect.
  # This is handled by importing the ssh module, e.g.:
  # imports = [ ../../services/ssh.nix ];
}

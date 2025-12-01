# common.nix - Shared configuration for all hosts
{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    # Core system modules
    ./system/boot.nix
    ./system/network.nix
    ./system/users.nix
    ./system/packages.nix
    ./system/nix.nix
    ./system/sops.nix
    ./system/claude-code-router.nix

    # Essential services
    ./services/ssh.nix
    ./services/tailscale.nix
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # System state version - consistent across all hosts
  system.stateVersion = "24.11";
}

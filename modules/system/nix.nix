{ config, lib, pkgs, ... }:

{
  # Nix Configuration
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  
  # Security
  security.rtkit.enable = true;
}
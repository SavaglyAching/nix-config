{ config, lib, pkgs, ... }:

{
  # Nix Configuration
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  programs.zsh.enable = true;

  # Security
  security.rtkit.enable = true;
}
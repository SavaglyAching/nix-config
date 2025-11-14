{ config, pkgs, ... }:

{
  programs.nh = {
    enable = true;

    # Set the flake path for your configuration
    flake = "/home/ham/nix-config";

    # Enable automatic garbage collection
    clean = {
      enable = true;
      dates = "weekly";
      extraArgs = "--keep 5 --keep-since 7d";
    };
  };
}

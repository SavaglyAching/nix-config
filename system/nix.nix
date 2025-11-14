#modules/system/nix.nix

{ config, lib, pkgs, ... }:

{
  # Nix Configuration
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  programs.zsh.enable = true;

  # nh - NixOS Helper
  programs.nh = {
    enable = true;
    clean.enable = false;  # Disabled: using Home Manager config instead
  };

  # direnv - Load environment variables from .envrc files
  programs.direnv.enable = true;

  # --- Automatic Garbage Collection ---
  # This is recommended to run alongside auto-updates to free up disk space.

  # Security
  security.rtkit.enable = true;

  i18n = {
    defaultLocale = "en_CA.UTF-8";
    supportedLocales = [ "en_CA.UTF-8/UTF-8" "en_US.UTF-8/UTF-8" ];
  };
}
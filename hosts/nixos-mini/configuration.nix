{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./main.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos-mini";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Moncton";
  i18n.defaultLocale = "en_CA.UTF-8";


  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "nixos-unstable";
}

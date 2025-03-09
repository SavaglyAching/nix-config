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

  users.users.ham = {
    isNormalUser = true;
    description = "ham";
    extraGroups = [ "networkmanager" "wheel" "docker" "video" "render" "audio" ];
    hashedPassword = "$y$j9T$eu6NU3IkxSdMtMny7ByOR/$TJkLnpcQzjzB3slDx8dO4DtYwNOnygHNopJ0sqE5za/";
    packages = with pkgs; [  ];
  };

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "nixos-unstable";
}

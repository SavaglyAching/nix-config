{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
     # System modules
    ../../modules/system/boot.nix
    ../../modules/system/network.nix
    ../../modules/system/users.nix
    ../../modules/system/shell.nix
    ../../modules/system/packages.nix
    ../../modules/system/nix.nix

    # Desktop environment (choose one)
    ../../modules/desktop/kde.nix
    
    # Services (uncomment as needed)
    ../../modules/services/ssh.nix
    ../../modules/services/tailscale.nix
    # ../../modules/services/ollama.nix
    ../../modules/services/docker.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos-mini";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Moncton";
  i18n.defaultLocale = "en_CA.UTF-8";


  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "nixos-24.11";
}

{ config, pkgs, lib, ... }:

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

  boot.loader.systemd-boot.enable = false;
 boot.loader.grub.enable = true;

  networking.hostName = "nixos-mini-vm";
  networking.networkmanager.enable = true;

 # Allow DHCP client traffic through the firewall (port 68)
 # This merges with rules from modules/system/network.nix
 networking.firewall.allowedUDPPorts = [ 68 ];

  time.timeZone = "America/Moncton";
  i18n.defaultLocale = "en_CA.UTF-8";


  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "24.11";
}

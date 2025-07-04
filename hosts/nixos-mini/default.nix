{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
     # System modules
    ../../modules/system/boot.nix
    ../../modules/system/network.nix
    ../../modules/system/users.nix
    
    ../../modules/system/packages.nix
    ../../modules/system/nix.nix
    ../../modules/system/sops-smb.nix

    # Desktop environment (choose one)
    # ../../modules/desktop/kde.nix
    
    # Services (uncomment as needed)
    ../../modules/services/ssh.nix
    ../../modules/services/tailscale.nix
    # ../../modules/services/ollama.nix
    # ../../modules/services/podman-mini.nix
    ../../home/home.nix # Home Manager configuration
  ];



  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
 boot.loader.grub.enable = lib.mkForce false; # Force GRUB disable for this host

  networking.hostName = "nixos-mini";
  networking.networkmanager.enable = true;

  
  # /etc/nixos/configuration.nix2



 # Allow DHCP client traffic through the firewall (port 68)
 # This merges with rules from modules/system/network.nix
 # networking.firewall.allowedUDPPorts = [ 68 ];

  time.timeZone = "America/Moncton";
  i18n.defaultLocale = "en_CA.UTF-8";


  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "24.11";

  # home-manager.users.ham = import ../../home/home.nix;
}

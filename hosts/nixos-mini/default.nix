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
    # ../../modules/desktop/kde.nix
    
    # Services (uncomment as needed)
    ../../modules/services/ssh.nix
    ../../modules/services/tailscale.nix
    # ../../modules/services/ollama.nix
    ../../modules/services/docker.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
 boot.loader.grub.enable = lib.mkForce false; # Force GRUB disable for this host

  networking.hostName = "nixos-mini";
  networking.networkmanager.enable = true;


  # /etc/nixos/configuration.nix

 fileSystems."/ip/Stuff" = {
  device = "//cloud/Stuff";
  fsType = "cifs";
  options = let
    # These options prevent the system from hanging at boot if the network is unavailable. [1, 2]
    automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
  in [
    # Get your UID and GID by running the `id` command in your terminal
    "${automount_opts},credentials=/home/ham/smb-secrets,uid=1000,gid=100,noserverino"
  ];
 };

 # Allow DHCP client traffic through the firewall (port 68)
 # This merges with rules from modules/system/network.nix
 # networking.firewall.allowedUDPPorts = [ 68 ];

  time.timeZone = "America/Moncton";
  i18n.defaultLocale = "en_CA.UTF-8";


  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "24.11";
}

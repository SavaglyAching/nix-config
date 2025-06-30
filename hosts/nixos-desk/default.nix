{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../home/home.nix
    ../../modules/system/boot.nix
    ../../modules/system/network.nix
    ../../modules/system/users.nix
    ../../modules/system/packages.nix
    ../../modules/system/nix.nix
    ../../modules/system/btrfs.nix
    ../../modules/system/remote-builder.nix
    ../../modules/desktop/kde.nix
    ../../modules/services/ssh.nix
    ../../modules/services/tailscale.nix

    
    ../../modules/services/docker.nix
    ../../modules/gaming/gaming.nix
    ../../modules/system/sops-smb.nix
    ../../modules/system/desktop.nix
  ];
  boot.kernelParams = [ "ip=dhcp" ];
  boot.initrd = {
    availableKernelModules = [ "r8169" ]; # IMPORTANT: Verify this module for your network card
    network = {
      enable = true;
      ssh = {
        enable = true;
        port = 22;
        authorizedKeys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGd3iG1U9JtdEtoTNCe/KyVHaK7DFkWQD7J4jnrZuvC+ u0_a302@localhost" ]; # IMPORTANT: Replace with your actual public SSH key
        hostKeys = [ "/etc/secrets/initrd/initrd_ssh_host_rsa_key" ];
        shell = "/bin/cryptsetup-askpass";
      };
    };
  };

  # Host-specific network configuration
  networking.hostName = "nixos-desk";
  networking.interfaces.enp14s0.wakeOnLan.enable = true;
  services.tailscale.useRoutingFeatures = "client";
  hardware.bluetooth.enable = true;
  time.timeZone = "America/Moncton";
  # Ensure ham is a trusted user for Nix operations, which is required for remote building.
  nix.settings.trusted-users = [ "ham" "root" ];
  networking.networkmanager.enable = true;
  # System state version
  system.stateVersion = "24.11";
}

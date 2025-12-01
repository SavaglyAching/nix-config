{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../common.nix

    # Additional system modules
    ../../system/sops.nix
    ../../services/samba-client.nix
    ../../services/samba-server-mini.nix
#    ../../services/syncthing.nix

    # Desktop environment (choose one)
    # ../../desktop/kde.nix
    ../../services/forgejo.nix
 #   ../../services/nixbuild.nix

    # Services (uncomment as needed)
    # ../../services/ollama.nix
    ../../services/podman.nix
    ../../services/xrdp.nix
    #../../services/borgbackup-repo.nix

    # Container services
    ../../services/containers/karakeep.nix
    ../../services/containers/openhands.nix
    ../../services/containers/open-webui.nix
    ../../services/containers/tavern.nix
  ];


  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable =
    lib.mkForce false; # Force GRUB disable for this host

  networking.hostName = "mini";

  # /etc/nixos/configuration.nix2

  # Allow DHCP client traffic through the firewall (port 68)
  # This merges with rules from system/network.nix
  # networking.firewall.allowedUDPPorts = [ 68 ];

  time.timeZone = "America/Moncton";
  i18n.defaultLocale = "en_CA.UTF-8";

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "24.11";

}

{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../common.nix

    # Host-specific modules
    ../../system/btrfs.nix
    ../../system/remote-builder.nix
    ../../desktop/niri.nix
    ../../services/podman.nix
    ../../services/flatpak.nix
    #    ../../services/containers/audiobookshelf.nix
    #../../services/ollama.nix
    #../../services/vm/windows-vm.nix
    ../../gaming/gaming.nix
    ../../hardware/amd.nix
    ../../system/sops.nix
    ../../services/samba-client.nix
    ../../services/syncthing.nix
    #   ../../services/containers/audiobookshelf.nix
  ];

  boot.kernelParams = [ "ip=dhcp" ];
  boot.initrd = {
    availableKernelModules = [ "r8169" ]; # IMPORTANT: Verify this module for your network card
    network = {
      enable = true;
      ssh = {
        enable = true;
        port = 22;
        authorizedKeys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGd3iG1U9JtdEtoTNCe/KyVHaK7DFkWQD7J4jnrZuvC+ u0_a302@localhost"
        ]; # IMPORTANT: Replace with your actual public SSH key
        hostKeys = [ "/etc/secrets/initrd/initrd_ssh_host_rsa_key" ];
        shell = "/bin/cryptsetup-askpass";
      };
    };
  };

  # Host-specific network configuration
  networking.hostName = "desk";
  networking.interfaces.enp14s0.wakeOnLan.enable = true;
  services.tailscale.useRoutingFeatures = "client";
  time.timeZone = "America/Moncton";
  # Ensure ham is a trusted user for Nix operations, which is required for remote building.
  nix.settings.trusted-users = [
    "ham"
    "root"
  ];

  # Enable building for ARM64 systems (e.g., asahi)
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  networking.networkmanager.enable = true;
  # System state version
  system.stateVersion = "24.11";
}

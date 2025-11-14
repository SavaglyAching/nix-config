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
    ../../system/shell.nix
    ../../desktop/niri.nix
  ];

  networking.hostName = "niri-vm";
  time.timeZone = "UTC";

  # VM friendly defaults
  services.qemuGuest.enable = true;
  virtualisation = {
    memorySize = 4096;
    cores = 4;
    diskSize = 16384; # MiB
    useNixStoreImage = true;
    rootDevice = "/dev/disk/by-label/nixos";
  };

  # Convenience for interactive testing
  users.users.ham = {
    initialPassword = "ham";
  };
  users.users.root.initialPassword = "root";
  services.getty.autologinUser = "ham";
  security.sudo.wheelNeedsPassword = false;

  environment.systemPackages = with pkgs; [
    git
    neovim
  ];

  system.stateVersion = "24.11";
}

{ config, lib, pkgs, ... }:

{
  # Import the base Samba module
  imports = [
    ../../modules/services/samba.nix
  ];

  # Host-specific Samba configuration
  services.samba = {
    settings = {
      global = {
        "server string" = "nixos-rica";
        "netbios name" = lib.mkForce "nixos-rica";
      };
      persist = {
        path = "/persist";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0664";
        "directory mask" = "0775";
        "force user" = "ham";
        "valid users" = "ham";
      };
    };
  };
}
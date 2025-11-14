{ config, lib, pkgs, ... }:

{
  # Samba Server for desk host
  services.samba = {
    enable = true;
    settings = {
      global = {
        workgroup = "WORKGROUP";
        "server string" = "desk";
        "netbios name" = lib.mkForce "desk";
        "server min protocol" = "SMB3";
        "dns proxy" = "no";
        "security" = "user";
      };
      # Share for /home/ham/git-projects/ttdl
      ttdl = {
        path = "/home/ham/git-projects/ttdl";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0664";
        "directory mask" = "0775";
        "force user" = "ham";
        "force group" = "users";
        "valid users" = "ham";
        "comment" = "TTDL directory for ham user";
      };
    };
  };
}
{ config, lib, pkgs, ... }:

{
  # Samba Server for mini host
  services.samba = {
    enable = true;
    settings = {
      global = {
        workgroup = "WORKGROUP";
        "server string" = "mini";
        "netbios name" = "mini";
        "server min protocol" = "SMB3";
        "dns proxy" = "no";
        "security" = "user";
      };
      # Share for /home/ham/ttdl
      ttdl = {
        path = "/home/ham/ttdl";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0664";
        "directory mask" = "0775";
        "force user" = "ham";
        "force group" = "users";
        "valid users" = "ham";
        "comment" = "TTDL directory";
      };
    };
  };
}

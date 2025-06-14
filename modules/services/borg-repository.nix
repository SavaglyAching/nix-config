{ config, lib, pkgs, ... }:

{
  services.borgbackup.repos."vorta-backup" = {
    path = "/persist/borgrepo";
    user = "borg";
    group = "borg";
    appendOnly = true;
  };
}
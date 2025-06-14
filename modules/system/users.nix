{ config, lib, pkgs, ... }:

{
  users = {
    defaultUserShell = pkgs.zsh;
    users = {
      ham = {
        isNormalUser = true;
        extraGroups = [ "wheel" "samba" "docker" "waydroid" "networkmanager" "video" "render" "audio" ];
        shell = pkgs.zsh;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHqNpQzPXCgbUM3EA99GXlfeL8nnDDhJEqH+ZzLy84GO j@deskv"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF5ryKKKc1NZBKj/wXIQynMvcIGQ0knE/hXfc+d4UCMn surface-remote-builder"
        ];
      };
      borg = {
        isSystemUser = true;
        group = "borg";
        home = "/persist/borgrepo";
        createHome = true;
        homeMode = "0700";
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPk0FdeztGZkHjKjURPlrXCWAdtW2rLyxFD79T9W/8KE app@unraid-vorta"
        ];
      };
    };
    groups.borg = {};
  };
}

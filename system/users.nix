{ config, lib, pkgs, ... }:

{
  users = {
    defaultUserShell = pkgs.zsh;
    users = {
      ham = {
        isNormalUser = true;
        extraGroups = [
          "wheel"
          "networkmanager"
          "video"
          "render"
          "audio"
          "input"
        ]
        ++ lib.optional (config.services.samba.enable or config.services.samba-wsdd.enable or false) "samba"
        ++ lib.optional (config.virtualisation.docker.enable or false) "docker"
        ++ lib.optional (config.virtualisation.waydroid.enable or false) "waydroid";
        shell = pkgs.zsh;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHqNpQzPXCgbUM3EA99GXlfeL8nnDDhJEqH+ZzLy84GO j@deskv"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAU436bK6EJ8RgdaxTQzg2KM887Ir5LbUtKKKIc/Mjh0 Remote builder key for rica"
        ];
      };
    };
  };
}

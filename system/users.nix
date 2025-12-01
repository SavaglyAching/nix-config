{ config, lib, pkgs, ... }:

{
  # Allow wheel group full passwordless sudo for Colmena deployments
  security.sudo.wheelNeedsPassword = false;

  # Additional specific rules for ham user
  security.sudo.extraRules = [
    {
      users = [ "ham" ];
      commands = [
        {
          command = "/run/current-system/sw/bin/podman";
          options = [ "NOPASSWD" ];
        }
        {
          command = "/run/current-system/sw/bin/systemctl";
          options = [ "NOPASSWD" ];
        }
        {
          command = "/run/current-system/sw/bin/nixos-rebuild";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

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
          config.sops.secrets."authorized_keys/user_ham_deskv".path
          config.sops.secrets."authorized_keys/user_ham_remote_builder".path
        ];
      };
    };
  };
}

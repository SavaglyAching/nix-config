{ config, pkgs, ... }:

{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/github";
        identitiesOnly = true;
      };

      "cloud-forgejo" = {
        hostname = "cloud";
        port = 2212;
        user = "ham";
        identityFile = "~/.ssh/github";
        identitiesOnly = true;
      };

      "sops-*" = {
        identityFile = "~/.ssh/sops";
        identitiesOnly = true;
      };
    };
  };
}

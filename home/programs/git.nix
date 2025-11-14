{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "git";
        email = "git@bloood.ca";
      };

      credential.username = "ham";

      safe.directory = [
        "/etc/nixos"
        "/docker"
        "/pmc-main"
      ];

      alias = {
        addpush = "!cd /etc/nixos && sudo git add . && sudo git commit -m \"Automated Commit\" && sudo git push";
        nixauto = "!cd /etc/nixos && sudo git add . && sudo git commit -m \"Automated Commit\" && sudo git push";
        nix = "!cd /etc/nixos && sudo git add . && sudo git commit -m \"Automated Commit\" && sudo git push";
      };
    };
  };
}

{ config, lib, pkgs, ... }:

{
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      PubkeyAuthentication = true;
    };
    extraConfig = ''
      # Allow TCP forwarding for Nix remote builds
      AllowTcpForwarding yes
    '';
  };
}
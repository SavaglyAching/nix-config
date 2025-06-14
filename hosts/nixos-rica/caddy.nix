{ config, lib, pkgs, ... }:

{
  services.caddy = {
    enable = true;
    extraConfig = ''
      unraid.jadenmae.com {
        reverse_proxy cloud:80
      }
    '';
  };
}
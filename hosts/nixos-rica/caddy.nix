{ config, lib, pkgs, ... }:

{
  services.caddy = {
    enable = true;
    extraConfig = ''
      unraid.jadenmae.com {
        reverse_proxy 100.122.111.121:80
      }
    '';
  };
}
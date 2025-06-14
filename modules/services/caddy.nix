{ config, lib, pkgs, ... }:

{
  services.caddy = {
    enable = true;
    virtualHosts."unraid.jadenmae.com" = {
      extraConfig = ''
        reverse_proxy 100.122.111.121:80
      '';
    };
  };
}
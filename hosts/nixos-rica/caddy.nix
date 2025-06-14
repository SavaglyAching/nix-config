{ config, lib, pkgs, ... }:

{
  services.caddy = {
    enable = true;
    virtualHosts."100.122.111.121" = {
      extraConfig = ''
        reverse_proxy 100.122.111.121:80
      '';
    };
  };
}
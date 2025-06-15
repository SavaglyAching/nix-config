{ config, lib, pkgs, ... }:

{
  services.caddy = {
    enable = true;
    virtualHosts = {
      "unraid.jadenmae.com" = {
        extraConfig = ''
          reverse_proxy http://cloud:80
        '';
      };
    };
  };
}
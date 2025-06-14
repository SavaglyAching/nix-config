{ config, lib, pkgs, ... }:

{
  services.caddy = {
    enable = true;
    extraConfig = ''
      unraid.bloood.ca {
        reverse_proxy 100.122.111.121:80
      }
    '';
  };
}
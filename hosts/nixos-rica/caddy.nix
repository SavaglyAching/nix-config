{ config, lib, pkgs, ... }:

{
  services.caddy = {
    enable = true;
    virtualHosts = {
      "unraid.jadenmae.com" = {
        proxies = {
          "/" = {
            upstream = "http://cloud:80";
          };
        };
      };
    };
  };
}
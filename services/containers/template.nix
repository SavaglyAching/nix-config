{ config, lib, pkgs, ... }:

{
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  virtualisation.oci-containers = {
    backend = "podman";
    containers = {
      claude-code-proxy = {
        image = "ghcr.io/1rgs/claude-code-proxy:latest";
        autoStart = true;
        ports = [ "13378:80" ];
        volumes = [
          "/home/ham/containers/audiobookshelf/audiobooks:/audiobooks"
          "/home/ham/containers/audiobookshelf/podcasts:/podcasts"
          "/home/ham/containers/audiobookshelf/config:/config"
          "/home/ham/containers/audiobookshelf/metadata:/metadata"
        ];
        extraOptions = [
          "--pull=newer"
        ];
      };
    };
  };
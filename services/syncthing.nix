{ config, lib, pkgs, ... }:

{
  services.syncthing = {
    enable = true;
    user = "ham";
    dataDir = "/home/ham";
    configDir = "/home/ham/.config/syncthing";

    settings = {
      options = {
        # Disable global discovery and relaying since we're using Tailscale
        globalAnnounceEnabled = false;
        relaysEnabled = false;
        # Use local discovery within Tailscale network
        localAnnounceEnabled = true;
        natEnabled = false;
      };

      # Share git-projects folder
      folders = {
        "git-projects" = {
          path = "/home/ham/git-projects";
          # Devices will be added via the web UI after initial setup
          # since we need to exchange device IDs between hosts
          devices = [ ];
          versioning = {
            type = "simple";
            params = {
              keep = "5";
            };
          };
        };
      };

      # Devices will be configured after getting device IDs from each host
      devices = { };
    };
  };
}

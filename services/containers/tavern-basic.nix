{ config, pkgs, ... }:

{
  virtualisation.oci-containers.backend = "podman";
  virtualisation.oci-containers.containers = {
    tavern = {
      image = "tavernai/tavernai:latest";
      autoStart = true;
      ports = [ "0.0.0.0:8000:8000" ];
      volumes = [
        "tavern-data:/app/home"
        "tavern-characters:/app/public/characters"
      ];
      environment = {
        NODE_ENV = "production";
        # These can be configured in the web UI or via environment variables
        # To add API keys later, use: podman exec -it tavern bash
        # Then set environment variables in the container
        DEFAULT_BACKEND = "openrouter";
      };
      extraOptions = [
        "--pull=newer"
        "--restart=unless-stopped"
      ];
    };
  };

  # Open port 8000 for Tavern web interface
  networking.firewall.allowedTCPPorts = [ 8000 ];
}
{ config, lib, pkgs, ... }:

{
  # Enable Podman and Docker compatibility
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  # OCI container configuration for claude-code-proxy
  virtualisation.oci-containers = {
    backend = "podman";
    containers = {
      claude-code-proxy = {
        image = "ghcr.io/1rgs/claude-code-proxy:latest";
        autoStart = true;
        ports = [ "8082:8082" ];
        extraOptions = [
          "--pull=newer"
        ];
        # Environment variables for claude-code-proxy
        environment = {
          "OPENAI_API_KEY" = "$(cat ${config.sops.secrets.OPENROUTER_API_KEY.path})";
          "PREFERRED_PROVIDER" = "openai";
        };
      };
    };
  };
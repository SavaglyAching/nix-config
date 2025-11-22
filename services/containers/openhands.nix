{ config, ... }:

{
  # SOPS template for OpenHands environment file
  sops.templates."openhands.env" = {
    content = ''
      # LLM API Configuration
      LLM_API_KEY=${config.sops.placeholder.OPENROUTER_API_KEY}
      LLM_MODEL=z-ai/glm-4.6
      LLM_BASE_URL=https://openrouter.ai/api/v1

      # Sandbox configuration
      SANDBOX_RUNTIME_CONTAINER_IMAGE=docker.openhands.dev/openhands/runtime:0.62-nikolaik
      SANDBOX_USER_ID=1000
      LOG_ALL_EVENTS=true
    '';
    mode = "0400";
  };

  virtualisation.oci-containers.backend = "podman";
  virtualisation.oci-containers.containers = {
    openhands = {
      image = "docker.openhands.dev/openhands/openhands:latest";
      autoStart = true;
      ports = [ "42069:3000" ];
      volumes = [
        "/home/ham/containers/openhands:/.openhands"
        "/run/podman/podman.sock:/var/run/docker.sock"
      ];
      environmentFiles = [
        config.sops.templates."openhands.env".path
      ];
      extraOptions = [
        "--pull=newer"
        "--add-host=host.docker.internal:host-gateway"
      ];
    };
  };

  # Create persistent storage directory
  systemd.tmpfiles.rules = [
    "d /home/ham/containers/openhands 0755 ham users -"
  ];
}

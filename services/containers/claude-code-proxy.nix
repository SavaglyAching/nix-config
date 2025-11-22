{ config, lib, pkgs, ... }:

{
  # SOPS template for environment file
  sops.templates."claude-code-proxy.env" = {
    content = ''
      OPENAI_API_KEY=${config.sops.placeholder.OPENROUTER_API_KEY}
      OPENAI_API_BASE=https://openrouter.ai/api/v1
      PREFERRED_PROVIDER=openai
      BIG_MODEL=moonshotai/kimi-k2-thinking
      SMALL_MODEL=moonshotai/kimi-k2
    '';
    mode = "0400";
  };

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
        image = "ghcr.io/1rgs/claude-code-proxy:main";
        autoStart = true;
        ports = [ "8082:8082" ];
        extraOptions = [
          "--pull=newer"
        ];
        environmentFiles = [
          config.sops.templates."claude-code-proxy.env".path
        ];
      };
    };
  };
}
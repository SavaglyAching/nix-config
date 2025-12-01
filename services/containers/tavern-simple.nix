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
        # Direct API keys from SOPS secrets
        OPENROUTER_API_KEY = config.sops.placeholder."OPENROUTER_API_KEY";
        OPENAI_API_KEY = config.sops.placeholder."karakeep_secrets/openai_api_key";
        GEMINI_API_KEY = config.sops.placeholder."GEMINI_API_KEY";
        PERPLEXITY_API_KEY = config.sops.placeholder."PERPLEXITY_API_KEY";
        ZAI_API_KEY = config.sops.placeholder."ZAI_API_KEY";

        # Default backend - can be changed in web UI
        DEFAULT_BACKEND = "openrouter";
        # Optional: Set default model
        # DEFAULT_MODEL = "anthropic/claude-3.5-sonnet";
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
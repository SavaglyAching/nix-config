{ config, ... }:

{
  # SOPS template for Tavern environment file with API keys
  sops.templates."tavern.env" = {
    content = ''
      # Tavern AI Configuration
      # OpenRouter API key (for various model access)
      OPENROUTER_API_KEY=${config.sops.placeholder."OPENROUTER_API_KEY"}

      # OpenAI API key
      OPENAI_API_KEY=${config.sops.placeholder."karakeep_secrets.openai_api_key"}

      # Gemini API key
      GEMINI_API_KEY=${config.sops.placeholder."GEMINI_API_KEY"}

      # Perplexity API key
      PERPLEXITY_API_KEY=${config.sops.placeholder."PERPLEXITY_API_KEY"}

      # ZAI API key
      ZAI_API_KEY=${config.sops.placeholder."ZAI_API_KEY"}
    '';
    mode = "0400";
  };

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
        # Tavern will use the API keys from the environment file
        # Default backend - can be changed in the web UI
        DEFAULT_BACKEND = "openrouter";
        # Optional: Set default model
        # DEFAULT_MODEL = "anthropic/claude-3.5-sonnet";
      };
      environmentFiles = [
        config.sops.templates."tavern.env".path
      ];
      extraOptions = [
        "--pull=newer"
        "--name=tavern"
        "--restart=unless-stopped"
      ];
    };
  };

  # Open port 8000 for Tavern web interface
  networking.firewall.allowedTCPPorts = [ 8000 ];
}
{ config, ... }:

{
  # SOPS template for environment file
  sops.templates."karakeep.env" = {
    content = ''
      # Karakeep web environment
      NEXTAUTH_SECRET=${config.sops.placeholder."karakeep_secrets/nextauth_secret"}
      OPENAI_BASE_URL=https://openrouter.ai/api/v1
      OPENAI_API_KEY=${config.sops.placeholder."karakeep_secrets/openai_api_key"}
      INFERENCE_TEXT_MODEL=google/gemini-2.5-flash
      INFERENCE_IMAGE_MODEL=google/gemini-2.5-flash
      
      # Meilisearch environment
      MEILI_MASTER_KEY=${config.sops.placeholder."karakeep_secrets/meili_master_key"}
      MEILI_NO_ANALYTICS=true
    '';
    mode = "0400";
  };

  virtualisation.oci-containers.backend = "podman";
  virtualisation.oci-containers.containers = {
    karakeep-web = {
      image = "ghcr.io/karakeep-app/karakeep:release";
      autoStart = true;
      ports = [ "3001:3000" ];
      volumes = [
        "karakeep-data:/data"
      ];
      environment = {
        KARAKEEP_VERSION = "release";
        MEILI_ADDR = "http://karakeep-meilisearch:7700";
        BROWSER_WEB_URL = "http://karakeep-chrome:9222";
        DATA_DIR = "/data";
        NEXTAUTH_URL = "http://localhost:3000";
      };
      environmentFiles = [
        config.sops.templates."karakeep.env".path
      ];
      dependsOn = [ "karakeep-chrome" "karakeep-meilisearch" ];
    };

    karakeep-chrome = {
      image = "gcr.io/zenika-hub/alpine-chrome:124";
      autoStart = true;
      cmd = [
        "--no-sandbox"
        "--disable-gpu"
        "--disable-dev-shm-usage"
        "--remote-debugging-address=0.0.0.0"
        "--remote-debugging-port=9222"
        "--hide-scrollbars"
      ];
    };

    karakeep-meilisearch = {
      image = "getmeili/meilisearch:v1.13.3";
      autoStart = true;
      volumes = [
        "karakeep-meilisearch:/meili_data"
      ];
      environmentFiles = [
        config.sops.templates."karakeep.env".path
      ];
    };
  };
}
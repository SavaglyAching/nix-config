{ config, ... }:

{
  # SOPS template for OpenWebUI environment file
  sops.templates."open-webui.env" = {
    content = ''
      WEBUI_SECRET_KEY=${config.sops.placeholder."open-webui-secret-key"}
    '';
    mode = "0400";
  };

  virtualisation.oci-containers.backend = "podman";
  virtualisation.oci-containers.containers = {
    open-webui = {
      image = "ghcr.io/open-webui/open-webui:main";
      autoStart = true;
      ports = [ "0.0.0.0:42169:8080" ];
      volumes = [
        "open-webui-data:/app/backend/data"
      ];
      environment = {
        OLLAMA_BASE_URL = "http://desk:11434";
        ENABLE_RAG_WEB_SEARCH = "true";
        ENABLE_IMAGE_GENERATION = "true";
      };
      environmentFiles = [
        config.sops.templates."open-webui.env".path
      ];
      extraOptions = [
        "--pull=newer"
      ];
    };
  };
}

{
  virtualisation.podman = {
    enable = true;
  };

  virtualisation.oci-containers.containers."ytptube" = {
    image = "ghcr.io/arabcoders/ytptube:latest";
    ports = [ "8081:8081" ];
    volumes = [ "ytptube-data:/downloads" ];
    user = "1000:1000";
    environment = {
      "YTP_MAX_WORKERS" = "999"; # Effectively unlimited concurrent downloads
      "YTP_CONSOLE_ENABLED" = "true"; # Enable console
    };
    extraOptions = [ "--restart=unless-stopped" ];
  };
}

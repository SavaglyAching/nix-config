{
  virtualisation.docker.containers."metube" = {
    image = "arabcoders/ytptube";
    ports = [ "8081:8081" ];
    volumes = [ "/home/ham/metube-downloads:/downloads" ];
    environment = {
      "YTDL_OPTIONS" = builtins.toJSON {
        retries = "infinite";
        fragment_retries = "infinite";
        socket_timeout = 90;
        no_part = true;
      };
      "DOWNLOAD_MODE" = "concurrent";
      "NTFY_URL" = "http://100.105.83.87:6789";
      "NTFY_TOPIC" = "metube";
    };
  };
}
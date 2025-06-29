{
  virtualisation.oci-containers.containers."metube" = {
    image = "alextaaga/metube";
    ports = [ "8081:8081" ];
    volumes = [ "/home/ham/metube-downloads:/downloads" ];
    dependsOn = [ "ntfy" ];
    environment = {
      "YTDL_OPTIONS" = builtins.toJSON {
        retries = "infinite";
        fragment_retries = "infinite";
        socket_timeout = 90;
        no_part = true;
      };
      "DOWNLOAD_MODE" = "concurrent";
      "NTFY_URL" = "http://cloud:80";
      "NTFY_TOPIC" = "metube";
    };
    extraOptions = [ "--restart=unless-stopped" ];
  };
{
  virtualisation.oci-containers.containers."ntfy" = {
    image = "binwiederhier/ntfy";
    ports = [ "6789:80" ];
    volumes = [
      "/home/ham/ntfy/cache:/var/cache/ntfy"
      "/home/ham/ntfy/config:/etc/ntfy"
    ];
    extraOptions = [
      "--restart=unless-stopped"
    ];
    command = [ "serve" ];
  };
}
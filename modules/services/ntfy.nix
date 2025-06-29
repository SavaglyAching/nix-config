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
    cmd = [ "serve" ];
  };
}
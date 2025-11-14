# Homepage Dashboard Container Service (Podman Rootless)
{ pkgs, lib, config, ... }:

{
  # Runtime handled by podman.nix module

  # Container
  virtualisation.oci-containers.containers."homepage" = {
    image = "ghcr.io/gethomepage/homepage:latest";
    volumes = [
      "/home/ham/.config/homepage:/app/config:rw"
      "/run/user/1000/podman/podman.sock:/var/run/docker.sock:ro"
    ];
    ports = [
      "3000:3000/tcp"
    ];
    user = "1000:1000";
    log-driver = "journald";
  };

  systemd.services."podman-homepage" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    wantedBy = [ "multi-user.target" ];
  };

  # Create config directory for user
  systemd.tmpfiles.rules = [
    "d /home/ham/.config/homepage 0755 ham ham -"
    "f /home/ham/.config/homepage/settings.yaml 0644 ham ham - ${builtins.toFile "settings.yaml" ''
      title: Dashboard
      background: https://images.unsplash.com/photo-1502790671504-542ad42d5189?auto=format&fit=crop&w=2560&q=80
      cardBlur: md
      theme: dark
      color: slate
      headerStyle: boxed
      layout:
        Services:
          style: row
          columns: 4
        System:
          style: row
          columns: 2
    ''}"
    "f /home/ham/.config/homepage/services.yaml 0644 ham ham - ${builtins.toFile "services.yaml" ''
      - Services:
        - Karakeep:
            href: http://localhost:8080
            description: Web archiving and search
            icon: si-archive
            ping: http://localhost:8080
        
      - System:
        - Portainer:
            href: http://localhost:9000
            description: Docker management
            icon: portainer.png
            ping: http://localhost:9000
    ''}"
    "f /home/ham/.config/homepage/widgets.yaml 0644 ham ham - ${builtins.toFile "widgets.yaml" ''
      - resources:
          backend: resources
          expanded: true
          cpu: true
          memory: true
          disk: /
          
      - search:
          provider: google
          target: _blank
    ''}"
    "f /home/ham/.config/homepage/docker.yaml 0644 ham ham - ${builtins.toFile "docker.yaml" ''
      my-podman:
        socket: /var/run/docker.sock
    ''}"
  ];
}
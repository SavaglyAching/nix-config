# Example configuration for containers.nix

{
  virtualisation.oci-containers.backend = "podman";
  virtualisation.oci-containers.containers = {
    container-name = {
      image = "container-image";
      autoStart = true;
      ports = [ "127.0.0.1:1234:1234" ];
      environment = {
        DATABASE_HOST = "db.example.com";
        DATABASE_PORT = "3306";
      };
    };
  };
}

## virtualisation.oci-containers.containers.<name>.environment
Environment variables to set for this container.
Type: attribute set of string
Default: { }

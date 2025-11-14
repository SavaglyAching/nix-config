# Podman rootless container runtime
{ pkgs, lib, config, ... }:

{
  # Enable common container config files in /etc/containers
  virtualisation.containers.enable = true;
  virtualisation = {
    podman = {
      enable = true;
      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;
      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  users.users.ham = {
    isNormalUser = true;
    extraGroups = [ "podman" ];
  };
}
{ config, lib, pkgs, ... }:

{
  # Wifi configuration module using NetworkManager
  # This module configures declarative wifi connections with passwords stored in SOPS secrets
  #
  # To add this to a host:
  # 1. Import this module in your host's default.nix: ../../system/wifi.nix
  # 2. Ensure NetworkManager is enabled: networking.networkmanager.enable = true;
  # 3. Add wifi passwords to secrets.yaml (see secrets-template.yaml for structure)
  # 4. Secrets are declared in system/sops.nix

  # SOPS template to create environment file for NetworkManager
  # Converts SOPS secret into KEY=value format required by NetworkManager
  sops.templates."wifi-fly-env" = {
    content = ''
      FLY_PASSWORD=${config.sops.placeholder."wifi/fly/password"}
    '';
    owner = "root";
    group = "root";
    mode = "0400";
  };

  # Declarative NetworkManager connection profiles
  networking.networkmanager.ensureProfiles = {
    environmentFiles = [
      config.sops.templates."wifi-fly-env".path
    ];

    profiles = {
      # Fly wifi access point
      fly = {
        connection = {
          id = "fly";
          type = "wifi";
          autoconnect = "true";
          permissions = "";
        };
        wifi = {
          ssid = "fly";
          mode = "infrastructure";
        };
        wifi-security = {
          key-mgmt = "wpa-psk";
          psk = "$FLY_PASSWORD";  # Variable loaded from environment file
        };
        ipv4 = {
          method = "auto";
        };
        ipv6 = {
          method = "auto";
        };
      };

      # Template for adding more networks:
      # home = {
      #   connection = {
      #     id = "home-network";
      #     type = "wifi";
      #     autoconnect = "true";
      #   };
      #   wifi = {
      #     ssid = "home-network";
      #     mode = "infrastructure";
      #   };
      #   wifi-security = {
      #     key-mgmt = "wpa-psk";
      #     psk = "$HOME_PASSWORD";  # Add corresponding secret and environment file
      #   };
      #   ipv4.method = "auto";
      #   ipv6.method = "auto";
      # };
    };
  };

  # Note: Wifi password secrets are declared in system/sops.nix
  # See docs/wifi-setup.md for complete setup instructions
}

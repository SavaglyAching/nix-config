{
  lib,
  config,
  pkgs,
  unstable,
  ...
}:

{
  # SOPS secrets management configuration
  sops = {
    defaultSopsFile = ../secrets.yaml;
    secrets = {
      # Network configuration secrets
      rica-server_ip = {
        owner = "root";
        group = "root";
        mode = "0400";
      };
      rica-server-gateway = {
        owner = "root";
        group = "root";
        mode = "0400";
      };

      # SMB credentials (individual fields)
      "smb_credentials/username" = {
        owner = "root";
        group = "root";
        mode = "0400";
      };
      "smb_credentials/password" = {
        owner = "root";
        group = "root";
        mode = "0400";
      };

      # API keys
      OPENROUTER_API_KEY = {
        owner = "ham";
        group = "users";
        mode = "0400";
      };
      GEMINI_API_KEY = {
        owner = "ham";
        group = "users";
        mode = "0400";
      };
      PERPLEXITY_API_KEY = {
        owner = "ham";
        group = "users";
        mode = "0400";
      };
      ZAI_API_KEY = {
        owner = "ham";
        group = "users";
        mode = "0400";
      };

      # Karakeep secrets
      "karakeep_secrets/meili_master_key" = {
        owner = "root";
        group = "root";
        mode = "0400";
      };
      "karakeep_secrets/nextauth_secret" = {
        owner = "root";
        group = "root";
        mode = "0400";
      };
      "karakeep_secrets/openai_api_key" = {
        owner = "root";
        group = "root";
        mode = "0400";
      };

      # Open WebUI secret key
      open-webui-secret-key = {
        owner = "root";
        group = "root";
        mode = "0400";
      };

      # SSH authorized keys for user accounts
      "authorized_keys/desk_remote_unlock" = {
        owner = "root";
        group = "root";
        mode = "0400";
      };
      "authorized_keys/user_ham_deskv" = {
        owner = "ham";
        group = "users";
        mode = "0400";
      };
      "authorized_keys/user_ham_remote_builder" = {
        owner = "ham";
        group = "users";
        mode = "0400";
      };

      # Borgbackup SSH authorized keys
      "authorized_keys/mac" = {
        owner = "root";
        group = "root";
        mode = "0400";
      };

      # Wifi passwords
      "wifi/fly/password" = {
        owner = "root";
        group = "root";
        mode = "0400";
      };

      # Attic binary cache token
      attic_token = {
        owner = "root";
        group = "root";
        mode = "0400";
      };

    };
  };

  # SOPS package for managing secrets
  environment.systemPackages = with pkgs; [ (unstable.sops) ];
}

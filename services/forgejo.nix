{
  config,
  lib,
  pkgs,
  ...
}:

{
  # SOPS secret declarations
  sops.secrets."forgejo/admin_username" = {
    owner = "forgejo";
    group = "forgejo";
    mode = "0400";
  };
  sops.secrets."forgejo/admin_password" = {
    owner = "forgejo";
    group = "forgejo";
    mode = "0400";
  };

  services.forgejo = {
    enable = true;  # Enabled: admin credentials configured in SOPS secrets

    # Database configuration
    database = {
      type = "sqlite3";
      createDatabase = true;
    };

    # LFS support for large files
    lfs.enable = true;

    # Server settings
    settings = {
      server = {
        # DOMAIN = "git.bloood.ca";
        # HTTP_ADDR = "127.0.0.1";
        HTTP_PORT = 4445;
        # ROOT_URL = "https://git.bloood.ca/";
        DISABLE_SSH = false;
        SSH_PORT = 2222;
        SSH_LISTEN_PORT = 2222;
      };

      # Service settings
      service = {
        # DISABLE_REGISTRATION = true;
        REQUIRE_SIGNIN_VIEW = true;
      };

      # Security settings
      security = {
        INSTALL_LOCK = true;
      };

      # Session settings
      session = {
        COOKIE_SECURE = true; # HTTPS is being used
        COOKIE_NAME = "forgejo_session";
      };

      # Log settings
      log = {
        LEVEL = "Info";
        MODE = "console, file";
      };
    };

    # Enable automatic database dumps
    dump = {
      enable = true;
      interval = "daily";
      backupDir = "/var/lib/forgejo/dump";
      type = "tar.zst";
    };
  };

  # No firewall ports opened - using reverse proxy (Caddy)
}

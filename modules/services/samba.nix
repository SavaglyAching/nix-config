{ config, lib, pkgs, ... }:

{
  # Samba File Sharing
  services.samba = {
    enable = true;
    settings = {
      global = {
        workgroup = "WORKGROUP";
        # "netbios name" is set in host-specific config
        "map to guest" = "bad user";
        "server min protocol" = "SMB2";
        "dns proxy" = "no";
        "socket options" = "TCP_NODELAY SO_RCVBUF=65536 SO_SNDBUF=65536";
        "security" = "user";
      };
    };
    # Shares are defined in host-specific configurations
  };
}
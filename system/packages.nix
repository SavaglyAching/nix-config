{
  config,
  lib,
  pkgs,
  ...
}:

{
  # System Packages
  environment = {
    systemPackages = with pkgs; [
      # Terminal and system tools
      age
      btop
      htop
      mosh
      ncdu
      bun
      nodejs
      sops
      eza

      # System administration
      btrfs-progs
      dnsutils
      iotop
      nmap
      wakeonlan

      # File management and utilities
      cowsay
      curl
      exfatprogs
      nix-search-tv
      wget
      unzip

      # Development tools
      opencode
      git
      python3
      stow
      uv
      podman-compose
      docker-compose

      # Media tools
      ffmpeg-full
    ];

    pathsToLink = [ "/share/zsh" ];

  };
}

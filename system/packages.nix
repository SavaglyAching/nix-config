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
      ssh-to-age
      eza

      # System administration
      btrfs-progs
      colmena
      dnsutils
      iotop
      nmap
      nix-fast-build
      wakeonlan

      # File management and utilities
      cowsay
      curl
      ripgrep
      exfatprogs
      nix-search-tv
      wget
      unzip

      # Development tools
      opencode
      git
      gh
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

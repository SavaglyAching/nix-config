{
  config,
  lib,
  pkgs,
  ai-tools,
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
      git
      gh
      python3
      stow
      uv
      podman-compose
      docker-compose
      nix-direnv

      # Media tools
      ffmpeg-full
     ] ++ [
       # AI tools from nix-ai-tools flake
       ai-tools.opencode
       ai-tools.gemini-cli
       ai-tools.claude-code
       ai-tools.codex
       ai-tools.claude-code-router
     ];

    pathsToLink = [ "/share/zsh" ];

  };
}

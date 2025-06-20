{ config, lib, pkgs, ... }:

{
  # Shell and Terminal Configuration


  programs = {
    zsh = {
      enable = true;
      # Use shellInit to set environment variables at Zsh startup
      # This runs before ~/.zshrc
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
      enableCompletion = true;
      shellAliases = {
        # NixOS management
        nr = "sudo nixos-rebuild switch";
        nrf = "sudo nixos-rebuild switch --flake .#";
        nm = "cd /etc/nixos";
        nixcfg = "cd /home/ham/Documents/nixos-test";
        # Editor shortcuts
        m = "sudo micro";
        mm = "sudo micro /home/ham/nixos-config/configuration.nix";
        # Docker management
        lzd = "lazydocker";
        lzg = "lazygit";
        # System monitoring
        htop = "btop";
        df = "ncdu";
        yt = "yt-dlp --retries infinite --fragment-retries infinite --socket-timeout 90";
        # Misc
        miniterm = "bash /scripts/terminal.sh";
      };
    };

    tmux = {
      enable = true;
      plugins = with pkgs; [
        tmuxPlugins.better-mouse-mode
      ];
    };

    mosh.enable = true;
  };
}

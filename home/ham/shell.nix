{ config, lib, pkgs, ... }:

{
  programs = {
    zsh = {
      enable = true;
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
        ttdl = "yt-dlp -o '/home/ham/ttdl/%(upload_date)s - %(title)s by %(uploader)s.%(ext)s' -a /home/ham/ttdl/urls.txt --download-archive /home/ham/ttdl/archive.txt";
        yt = "yt-dlp --retries infinite --fragment-retries infinite --socket-timeout 90 --no-part ";
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

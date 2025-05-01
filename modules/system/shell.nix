{ config, lib, pkgs, ... }:

{
  # Shell and Terminal Configuration
  programs = {
    # ZSH Configuration
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
        

        yt() {
            yt-dlp --retries infinite --fragment-retries infinite --socket-timeout 60 "$1"
            }
        }
        # Editor shortcuts
        m = "sudo micro";
        mm = "sudo micro /home/ham/nixos-config/configuration.nix";
        
        # Docker management
        lzd = "lazydocker";
        lzg = "lazygit";
        
        # System monitoring
        htop = "btop"; # btop is a better htop
        df = "ncdu"; # ncdu is a better df
        
        # Misc
        miniterm = "bash /scripts/terminal.sh";
      };
    };
    
    # TMUX Configuration
    tmux = {
      enable = true;
      plugins = with pkgs; [
        tmuxPlugins.better-mouse-mode
      ];
    };
    
    # Mosh Terminal
    mosh.enable = true;
  };
}
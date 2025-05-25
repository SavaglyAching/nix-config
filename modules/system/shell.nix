{ config, lib, pkgs, ... }: # This indicates the file is a NixOS module.

{
  # Shell and Terminal Configuration
  programs = { # Main 'programs' block

    # ZSH Configuration
    zsh = { # Zsh specific configurations
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
        htop = "btop"; # btop is a better htop
        df = "ncdu"; # ncdu is a better df
        
        # Misc
        miniterm = "bash /scripts/terminal.sh";
      }; # shellAliases block is closed

      # THIS IS CORRECTLY PLACED:
      initExtra = ''
        # Your Zsh function goes here, exactly as it would in .zshrc
        # (These comments below are for Zsh, so they correctly use # already)
        yt() {
            yt-dlp --retries infinite --fragment-retries infinite --socket-timeout 60 "$@"
        }

        # You can add other functions or Zsh commands here too
        # another_func() {
        #   echo "Hello from Zsh initExtra"
        # }
      ''; # initExtra is defined as a direct attribute of zsh
    }; # zsh block is closed
    
    # TMUX Configuration
    tmux = {
      enable = true;
      plugins = with pkgs; [
        tmuxPlugins.better-mouse-mode
      ];
    }; # tmux block is closed
    
    # Mosh Terminal
    mosh.enable = true;
  }; # programs block is closed
}
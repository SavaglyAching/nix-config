{ config, pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    mouse = true;

    extraConfig = ''
      # Status bar styling - match kitty gruvbox-dark-hard background
      set -g status-style 'bg=#1d2021,fg=white'
    '';
  };
}

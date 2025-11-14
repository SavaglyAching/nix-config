{ config, pkgs, ... }:

{
  # Zoxide integration
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
}

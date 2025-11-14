{ config, pkgs, ... }:

{
  programs.bash = {
    enable = true;
    shellAliases = {
      x = "exit";
    };
  };
}

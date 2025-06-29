{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "git";
    userEmail = "git@bloood.ca";
  };
}
# /home/ham/nix-config/home/home.nix
{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "ham";
  home.homeDirectory = "/home/ham";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.11";

  # Let Home Manager install and manage itself.
  imports = [
    ./ham/git.nix
    ./ham/ssh.nix
    ./ham/packages.nix
    ./ham/shell.nix
  ];

  programs.home-manager.enable = true;
}
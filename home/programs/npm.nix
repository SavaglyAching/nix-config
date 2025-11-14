{ config, pkgs, ... }:

{
  home.file.".npmrc".text = ''
    prefix=~/.npm-package
  '';

  # Add npm global bin directory to PATH
  home.sessionVariables = {
    PATH = "$HOME/.npm-package/bin:$PATH";
  };
}

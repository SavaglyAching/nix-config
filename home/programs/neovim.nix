{ config, lib, pkgs, ... }:

{

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraPackages = with pkgs; [ neovim
    ];

    plugins = with pkgs.vimPlugins; [
      LazyVim
    ];
  };
}

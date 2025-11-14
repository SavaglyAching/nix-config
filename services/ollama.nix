{ config, lib, pkgs, ... }:

{
  services.ollama = {
    enable = true;
    acceleration = "rocm";
    host = "127.0.0.1";
    port = 11434;
    openFirewall = true;
    loadModels = [ "deepseek-r1:14b" ];
  };

  environment.systemPackages = [
    pkgs.ollama-rocm
  ];

}

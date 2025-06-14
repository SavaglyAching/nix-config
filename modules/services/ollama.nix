{ config, lib, pkgs, ... }:


{
  services.ollama = {
    enable = true;
    acceleration = "rocm";
    environmentVariables = {};
    host = "127.0.0.1";
    port = 11434;
    openFirewall = true;
  };

}
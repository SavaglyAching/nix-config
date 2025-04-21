{ config, lib, pkgs, ... }:
{

   # SSH Configuration for Distributed Builds
  programs.ssh = {
    extraConfig = ''
      Host eu.nixbuild.net
      PubkeyAcceptedKeyTypes ssh-ed25519
      ServerAliveInterval 60
      IPQoS throughput
      IdentityFile /home/ham/.ssh/my-nixbuild-key
    '';
    knownHosts = {
      nixbuild = {
        hostNames = [ "eu.nixbuild.net" ];
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPIQCZc54poJ8vqawd8TraNryQeJnvH1eLpIDgbiqymM";
      };
    };
  };
  


}

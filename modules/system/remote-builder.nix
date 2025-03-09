{ config, lib, pkgs, ... }:
{

   nix = {
  distributedBuilds = true;
  buildMachines = [{
    hostName = "192.168.2.254";  # Use Tailscale hostname
    system = "x86_64-linux";
    maxJobs = 8;
    speedFactor = 2;
    supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
    mandatoryFeatures = [ ];
    sshUser = "ham";
    sshKey = "/home/ham/.ssh/id_ed25519";
  }];
};


}

 { config, lib, pkgs, ... }:

{

  nix = {
    settings = {
      trusted-users = [ "root" "ham" ];
      builders-use-substitutes = true;
    };
    distributedBuilds = true;
    buildMachines = [
      {
        hostName = "nixos-desk";
        sshUser = "root";
        sshKey = "/root/.ssh/id_ed25519";
        system = "x86_64-linux";
        maxJobs = 100;
        supportedFeatures = [ "benchmark" "big-parallel" ];
      }
    ];

};
}
 

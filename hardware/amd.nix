{ config, pkgs, ... }:

{
  # AMD GPU driver configuration
  services.xserver.videoDrivers = [ "amdgpu" ];
  boot.kernelModules = [ "kvm-amd" ];
  # Enable hardware acceleration and 32-bit support
  hardware.graphics = {
    enable = true;
    enable32Bit = true;

    # AMD ROCm drivers for GPU compute
    # extraPackages = with pkgs; [
    #   rocmPackages.clr.icd
    # ];
  };

  # AMD-specific packages
  environment.systemPackages = with pkgs; [
    nvtopPackages.amd    # AMD GPU monitoring tool
    corectrl             # AMD GPU overclocking/fan control
  ];
}

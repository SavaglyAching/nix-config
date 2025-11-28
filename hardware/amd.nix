{ config, pkgs, ... }:

{
  # AMD GPU driver configuration
  services.xserver.videoDrivers = [ "amdgpu" ];
  boot.kernelModules = [ "kvm-amd" ];
  # Enable hardware acceleration and 32-bit support
  hardware.graphics = {
    enable = true;
    enable32Bit = true;

    # Vulkan drivers for AMD (RADV is enabled by default)
    extraPackages = with pkgs; [
      # rocmPackages.clr.icd  # ROCm for GPU compute (uncomment if needed)
    ];

    # 32-bit Vulkan support for Steam (RADV is enabled by default)
    extraPackages32 = with pkgs.driversi686Linux; [
    ];
  };

  # AMD-specific packages
  environment.systemPackages = with pkgs; [
    nvtopPackages.amd    # AMD GPU monitoring tool
    corectrl             # AMD GPU overclocking/fan control
  ];
}

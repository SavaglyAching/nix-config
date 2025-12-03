{ config, pkgs, ... }:

{
  # AMD GPU driver configuration
  services.xserver.videoDrivers = [ "amdgpu" ];
  boot.kernelModules = [ "kvm-amd" ];

    # Enable hardware acceleration and 32-bit support
  hardware.graphics = {
    enable = true;
    enable32Bit = true;

    # Vulkan drivers for AMD (RADV via mesa)
    extraPackages = with pkgs; [
      mesa
      # rocmPackages.clr.icd  # ROCm for GPU compute (uncomment if needed)
    ];

    # 32-bit Vulkan support for Steam
    extraPackages32 = with pkgs.driversi686Linux; [
      mesa
    ];
  };

  # AMD-specific packages
  environment.systemPackages = with pkgs; [
    nvtopPackages.amd    # AMD GPU monitoring tool
    corectrl             # AMD GPU overclocking/fan control
    vulkan-tools         # Vulkan validation and debugging tools (includes vulkaninfo)
    vulkan-loader        # Vulkan ICD loader - required for Steam pressure-vessel
    vulkan-validation-layers # Vulkan validation layers for debugging
  ];
}

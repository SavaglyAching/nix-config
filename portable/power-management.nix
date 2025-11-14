# portable/power-management.nix
# Modern power management for portable devices
# Uses auto-cpufreq (modern TLP replacement) and thermald

{ config, lib, pkgs, ... }:

{
  # Auto-cpufreq: Modern automatic CPU frequency scaling
  # Provides better battery life on portable devices
  services.auto-cpufreq = {
    enable = true;
    settings = {
      # Battery mode: Prioritize power saving
      battery = {
        governor = "powersave";
        scaling_min_freq = lib.mkDefault 400000;
        scaling_max_freq = lib.mkDefault 1800000;
        turbo = "never";
        enable_thresholds = true;
        start_threshold = 20;
        stop_threshold = 80;
      };

      # Charger mode: Prioritize performance
      charger = {
        governor = "performance";
        scaling_min_freq = lib.mkDefault 400000;
        scaling_max_freq = lib.mkDefault 3500000;
        turbo = "auto";
        enable_thresholds = false;
      };
    };
  };

  # Thermald: Intel thermal management daemon
  # Prevents overheating and manages thermal zones
  # Only enable on x86_64 systems (Intel-specific)
  services.thermald = {
    enable = lib.mkIf pkgs.stdenv.hostPlatform.isx86_64 true;
    # Use adaptive mode (DPTF tables from firmware)
    # This is recommended for modern Intel devices
  };

  # Enable general power management features
  powerManagement = {
    enable = true;
    powertop.enable = false; # Conflicts with auto-cpufreq
  };

  # UPower for battery status and power profiles
  services.upower = {
    enable = true;
    percentageLow = 15;
    percentageCritical = 5;
    percentageAction = 3;
    criticalPowerAction = "Hibernate";
  };
}

# portable/sensors.nix
# Sensor configuration for portable/tablet devices
# Enables accelerometer, gyroscope, and ambient light sensors

{ config, lib, pkgs, ... }:

{
  # IIO (Industrial I/O) sensor support
  # Required for screen auto-rotation and ambient light detection
  hardware.sensor.iio = {
    enable = true;
  };

  # Install iio-sensor-proxy
  # This daemon provides sensor data to applications via D-Bus
  environment.systemPackages = with pkgs; [
    iio-sensor-proxy
  ];

  # Ensure the user has access to input devices
  # Already configured in hosts/surface/default.nix but good to document here
  # users.users.ham.extraGroups = [ "input" "video" ];
}

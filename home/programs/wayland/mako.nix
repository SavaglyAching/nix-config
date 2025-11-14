{ ... }:

{
  # Notification daemon
  services.mako = {
    enable = true;
    settings = {
      font = "Inter 11";
      layer = "overlay";
      anchor = "top-right";
      background-color = "#181825E6";
      text-color = "#cdd6f4";
      border-color = "#89b4fa";
      border-radius = 12;
      border-size = 2;
      default-timeout = 5000;
    };
    extraConfig = ''
[low]
background-color=#313244
border-color=#94e2d5

[critical]
background-color=#b1628688
border-color=#f38ba8
'';
  };
}

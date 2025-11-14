{ pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    systemd.enable = true;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 32;
        spacing = 4;

        modules-left = [ "niri/workspaces" "niri/window" ];
        modules-center = [ "clock" ];
        modules-right = [
          "pulseaudio"
          "network"
          "bluetooth"
          "cpu"
          "memory"
          "temperature"
          "battery"
          "tray"
        ];

        "niri/workspaces" = {
          format = "{icon}";
          format-icons = {
            active = "󰄛";
            default = "󰄛";
          };
        };

        "niri/window" = {
          format = "{}";
          max-length = 50;
          rewrite = {
            "(.*) - Mozilla Firefox" = "🌎 $1";
            "(.*) - zsh" = "> [$1]";
          };
        };

        clock = {
          format = " {:%H:%M}";
          format-alt = " {:%Y-%m-%d}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "year";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 1;
            format = {
              months = "<span color='#ffead3'><b>{}</b></span>";
              days = "<span color='#ecc6d9'><b>{}</b></span>";
              weeks = "<span color='#99ffdd'><b>W{}</b></span>";
              weekdays = "<span color='#ffcc66'><b>{}</b></span>";
              today = "<span color='#ff6699'><b><u>{}</u></b></span>";
            };
          };
          actions = {
            on-click-right = "mode";
            on-scroll-up = "shift_up";
            on-scroll-down = "shift_down";
          };
        };

        cpu = {
          format = "󰍛 {usage}%";
          tooltip = false;
          interval = 2;
        };

        memory = {
          format = " {}%";
          tooltip-format = "RAM: {used:0.1f}G / {total:0.1f}G\nSwap: {swapUsed:0.1f}G / {swapTotal:0.1f}G";
          interval = 5;
        };

        temperature = {
          critical-threshold = 80;
          format = "{icon} {temperatureC}°C";
          format-icons = [
            ""
            ""
            ""
          ];
          interval = 5;
        };

        network = {
          format-wifi = " {essid}";
          format-ethernet = " {bandwidthUpBits}  {bandwidthDownBits}";
          format-linked = " {ifname} (No IP)";
          format-disconnected = "Disconnected";
          tooltip-format = "{ifname}: {ipaddr}/{cidr} ";
          interval = 1.5;
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = "󰖁 Muted";
          format-icons = {
            headphone = "󰋋";
            hands-free = "󰋎";
            headset = "󰋎";
            phone = "";
            portable = "";
            car = "";
            default = [
              "󰕿"
              "󰖀"
              "󰕾"
            ];
          };
          on-click = "pavucontrol";
          tooltip-format = "{desc}\nVolume: {volume}%";
        };

        bluetooth = {
          format = " {status}";
          format-connected = " {device_alias}";
          format-connected-battery = " {device_alias} {device_battery_percentage}%";
          format-disabled = "";
          format-off = "";
          tooltip-format = "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
          tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
          tooltip-format-enumerate-connected-battery = "{device_alias}\t{device_address}\t{device_battery_percentage}%";
          on-click = "blueman-manager";
        };

        tray = {
          icon-size = 16;
          spacing = 8;
        };
      };
    };

    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: "JetBrainsMono Nerd Font", "Font Awesome 6 Free";
        font-size: 13px;
        min-height: 0;
      }

      window#waybar {
        background-color: rgba(30, 30, 46, 0.9);
        color: #cdd6f4;
      }

      #workspaces {
        background-color: rgba(49, 50, 68, 0.8);
        border-radius: 4px;
        padding: 0 4px;
        margin: 0 4px;
      }

      #workspaces button {
        padding: 0 10px;
        margin: 0 2px;
        color: #89b4fa;
        background-color: rgba(30, 30, 46, 0.5);
        border-radius: 4px;
        min-width: 30px;
      }

      #workspaces button.focused {
        color: #1e1e2e;
        background-color: #f38ba8;
      }

      #workspaces button.active {
        color: #89b4fa;
        background-color: rgba(137, 180, 250, 0.2);
      }

      #workspaces button.empty {
        color: #6c7086;
        background-color: rgba(30, 30, 46, 0.3);
      }

      #workspaces button:hover {
        background-color: rgba(137, 180, 250, 0.3);
        color: #cdd6f4;
      }

      #window {
        padding: 0 10px;
        color: #a6e3a1;
      }

      #clock,
      #battery,
      #cpu,
      #memory,
      #temperature,
      #network,
      #pulseaudio,
      #bluetooth,
      #tray {
        padding: 0 10px;
        margin: 0 2px;
        background-color: rgba(49, 50, 68, 0.8);
        border-radius: 4px;
      }

      #clock {
        color: #f9e2af;
        font-weight: bold;
      }

      #battery {
        color: #a6e3a1;
      }

      #battery.charging {
        color: #a6e3a1;
      }

      #battery.warning:not(.charging) {
        color: #fab387;
      }

      #battery.critical:not(.charging) {
        color: #f38ba8;
        animation: blink 1s linear infinite;
      }

      @keyframes blink {
        to {
          background-color: rgba(243, 139, 168, 0.3);
        }
      }

      #cpu {
        color: #89dceb;
      }

      #memory {
        color: #cba6f7;
      }

      #temperature {
        color: #fab387;
      }

      #temperature.critical {
        color: #f38ba8;
        animation: blink 1s linear infinite;
      }

      #network {
        color: #94e2d5;
      }

      #network.disconnected {
        color: #f38ba8;
      }

      #pulseaudio {
        color: #f5c2e7;
      }

      #pulseaudio.muted {
        color: #6c7086;
      }

      #bluetooth {
        color: #89b4fa;
      }

      #bluetooth.disabled,
      #bluetooth.off {
        color: #6c7086;
      }

      #bluetooth.connected {
        color: #89b4fa;
      }

      #tray {
        background-color: rgba(49, 50, 68, 0.8);
      }
    '';
  };
}

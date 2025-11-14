# Hyprland NixOS Home Manager Configuration Guide

This guide covers configuring Hyprland through Home Manager in NixOS, based on the `wayland.windowManager.hyprland` module.

## Table of Contents
- [Overview](#overview)
- [Basic Configuration](#basic-configuration)
- [Settings Structure](#settings-structure)
- [Code Formatting Examples](#code-formatting-examples)
- [Complete Configuration Examples](#complete-configuration-examples)
- [Common Patterns](#common-patterns)
- [Troubleshooting](#troubleshooting)

## Overview

Hyprland is configured in Home Manager using the `wayland.windowManager.hyprland` namespace. The configuration uses a Nix attribute set structure that translates to Hyprland's native configuration format.

### Key Home Manager Options

- `wayland.windowManager.hyprland.enable` - Enable Hyprland configuration
- `wayland.windowManager.hyprland.package` - The Hyprland package to use
- `wayland.windowManager.hyprland.settings` - Main configuration in Nix format
- `wayland.windowManager.hyprland.extraConfig` - Raw Hyprland config lines
- `wayland.windowManager.hyprland.plugins` - List of Hyprland plugins
- `wayland.windowManager.hyprland.systemd.enable` - Enable systemd integration
- `wayland.windowManager.hyprland.xwayland.enable` - Enable XWayland support

## Basic Configuration

### Minimal Setup

```nix
{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    xwayland.enable = true;

    settings = {
      # Your configuration here
    };
  };
}
```

## Settings Structure

The `settings` attribute set follows Hyprland's configuration structure. All configuration is written in Nix syntax and converted to Hyprland format.

### Important Formatting Rules

1. **Lists for repeated keys**: Entries with the same key should be written as lists
2. **Quote variables and colors**: Variable names and color values should be quoted as strings
3. **Nested attributes**: Use attribute sets for nested configuration sections
4. **Booleans**: Use `true`/`false` (Nix booleans)
5. **Numbers**: Use plain numbers without quotes

## Code Formatting Examples

### Monitor Configuration

```nix
settings = {
  # Single monitor
  monitor = "eDP-1,1920x1080@60,0x0,1";

  # Multiple monitors (use list)
  monitor = [
    "DP-2,2560x1440@165,0x0,1"
    "HDMI-A-1,1920x1080@60,2560x0,1"
  ];

  # Dynamic monitor (from variable)
  monitor = if cfg.monitors != []
    then cfg.monitors
    else [ "eDP-1,preferred,auto,1" ];
};
```

### Environment Variables

```nix
settings = {
  env = [
    "XCURSOR_SIZE,24"
    "HYPRCURSOR_THEME,Bibata-Modern-Classic"
    "QT_QPA_PLATFORM,wayland;xcb"
    "GDK_BACKEND,wayland,x11"
    "SDL_VIDEODRIVER,wayland"
    "MOZ_ENABLE_WAYLAND,1"
  ];
};
```

### Startup Commands

```nix
settings = {
  exec-once = [
    "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
    "systemctl --user start hyprpolkitagent"
    "wl-paste --watch cliphist store"
    "${pkgs.waybar}/bin/waybar"
  ];
};
```

### Input Configuration

```nix
settings = {
  input = {
    kb_layout = "us";
    kb_variant = "";
    kb_model = "";
    kb_options = "";
    kb_rules = "";

    follow_mouse = 1;
    sensitivity = 0;  # -1.0 to 1.0, 0 means no modification

    touchpad = {
      natural_scroll = true;
      disable_while_typing = true;
      tap-to-click = true;
      clickfinger_behavior = false;
    };
  };
};
```

### General Appearance

```nix
settings = {
  general = {
    gaps_in = 6;
    gaps_out = 12;
    border_size = 3;
    "col.active_border" = "rgba(89b4faff)";
    "col.inactive_border" = "rgba(313244ff)";
    layout = "dwindle";
    allow_tearing = false;
  };
};
```

### Decorations

```nix
settings = {
  decoration = {
    rounding = 10;

    blur = {
      enabled = true;
      size = 4;
      passes = 2;
      new_optimizations = true;
      vibrancy = 0.1696;
    };

    shadow = {
      enabled = true;
      range = 20;
      render_power = 3;
      color = "0x44000000";
    };

    drop_shadow = true;
    shadow_range = 4;
    shadow_render_power = 3;
  };
};
```

### Animations

```nix
settings = {
  animations = {
    enabled = true;

    # Define bezier curves (list format)
    bezier = [
      "easeOutQuint,0.23,1,0.32,1"
      "easeInQuint,0.755,0.05,0.855,0.06"
      "linear,0,0,1,1"
      "popin,0.5,1.25,0.7,1"
    ];

    # Define animations (list format)
    animation = [
      "windows,1,7,default"
      "windowsOut,1,7,easeInQuint"
      "windowsMove,1,6,easeOutQuint"
      "border,1,10,default"
      "borderangle,1,8,default"
      "fade,1,7,linear"
      "workspaces,1,6,default"
    ];
  };
};
```

### Keybindings

```nix
settings = {
  # Define modifier key
  "$mod" = "SUPER";

  # Basic binds (list format)
  bind = [
    # Applications
    "$mod, RETURN, exec, kitty"
    "$mod, SPACE, exec, walker"
    "$mod, B, exec, firefox"

    # Window management
    "$mod, Q, killactive"
    "$mod SHIFT, Q, exit"
    "$mod, F, fullscreen, 0"
    "$mod, V, togglefloating"

    # Focus movement (Vim-style)
    "$mod, H, movefocus, l"
    "$mod, L, movefocus, r"
    "$mod, K, movefocus, u"
    "$mod, J, movefocus, d"

    # Window movement
    "$mod SHIFT, H, movewindow, l"
    "$mod SHIFT, L, movewindow, r"
    "$mod SHIFT, K, movewindow, u"
    "$mod SHIFT, J, movewindow, d"
  ];

  # Mouse bindings
  bindm = [
    "$mod, mouse:272, movewindow"
    "$mod, mouse:273, resizewindow"
  ];

  # Repeatable bindings (hold to repeat)
  binde = [
    ",XF86AudioRaiseVolume, exec, pamixer -i 5"
    ",XF86AudioLowerVolume, exec, pamixer -d 5"
  ];

  # Locked bindings (work even when locked)
  bindl = [
    ",XF86AudioMute, exec, pamixer -t"
  ];
};
```

### Dynamic Keybindings with Nix

```nix
settings = {
  "$mod" = "SUPER";

  bind =
    [
      # Static bindings
      "$mod, RETURN, exec, kitty"
    ]
    # Generate workspace bindings (1-9)
    ++ (map (n: "$mod, ${toString n}, workspace, ${toString n}") (lib.range 1 9))
    # Generate move to workspace bindings
    ++ (map (n: "$mod SHIFT, ${toString n}, movetoworkspace, ${toString n}") (lib.range 1 9));
};
```

### Window Rules

```nix
settings = {
  # Window rules v2 (recommended)
  windowrulev2 = [
    # Float specific applications
    "float, class:^(pavucontrol)$"
    "size 1024 640, class:^(pavucontrol)$"
    "float, class:^(nm-connection-editor)$"
    "float, class:^(blueman-manager)$"

    # Workspace assignment
    "workspace 10 silent,class:^(org.keepassxc.KeePassXC)$"
    "workspace 2,class:^(firefox)$"

    # Opacity rules
    "opacity 0.9 0.8,class:^(kitty)$"

    # Position rules
    "center,class:^(pavucontrol)$"
  ];

  # Layer rules
  layerrule = [
    "blur,waybar"
    "ignorezero,waybar"
  ];
};
```

### Layout Configuration

```nix
settings = {
  # Dwindle layout
  dwindle = {
    pseudotile = true;
    preserve_split = true;
    force_split = 0;
    split_width_multiplier = 1.0;
  };

  # Master layout
  master = {
    mfact = 0.55;
    new_status = "master";
    new_on_top = false;
  };
};
```

### Miscellaneous Settings

```nix
settings = {
  misc = {
    force_default_wallpaper = 0;
    disable_hyprland_logo = true;
    animate_manual_resizes = true;
    animate_mouse_windowdragging = true;
    focus_on_activate = true;
    vrr = 1;  # Variable refresh rate
    enable_swallow = true;
    swallow_regex = "^(kitty)$";
  };
};
```

### Gestures

```nix
settings = {
  gestures = {
    workspace_swipe = true;
    workspace_swipe_fingers = 3;
    workspace_swipe_distance = 300;
    workspace_swipe_cancel_ratio = 0.5;
  };
};
```

## Complete Configuration Examples

### Example 1: Minimal Desktop Setup

```nix
{ config, pkgs, lib, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;

    settings = {
      monitor = "eDP-1,1920x1080@60,0x0,1";

      exec-once = [
        "waybar"
        "mako"
      ];

      "$mod" = "SUPER";

      bind = [
        "$mod, RETURN, exec, kitty"
        "$mod, SPACE, exec, rofi -show drun"
        "$mod, Q, killactive"
        "$mod, F, fullscreen"
      ];

      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
      };
    };
  };
}
```

### Example 2: Modular Configuration (Recommended)

This is the approach used in this repository's Hyprland configuration.

**Main file** (`hyprland/default.nix`):
```nix
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.my.desktop.hyprland;
in
{
  imports = [
    ./hyprland-settings.nix
    ./keybindings.nix
    ./waybar.nix
    ./services.nix
  ];

  options.my.desktop.hyprland = {
    enable = mkEnableOption "Hyprland-based Wayland desktop session";

    monitors = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "Monitor definitions for Hyprland";
    };

    terminalCommand = mkOption {
      type = types.str;
      default = "${lib.getExe pkgs.kitty}";
      description = "Terminal command for keybindings";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      cliphist
      walker
    ];

    home.sessionVariables = {
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "wayland";
      MOZ_ENABLE_WAYLAND = "1";
    };
  };
}
```

**Settings file** (`hyprland-settings.nix`):
```nix
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.my.desktop.hyprland;
in
{
  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = true;

      settings = {
        monitor = if cfg.monitors != []
          then cfg.monitors
          else [ "eDP-1,preferred,auto,1" ];

        general = {
          gaps_in = 6;
          gaps_out = 12;
          border_size = 3;
        };

        # ... rest of settings
      };
    };
  };
}
```

**Keybindings file** (`keybindings.nix`):
```nix
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.my.desktop.hyprland;
  terminalCmd = cfg.terminalCommand;
in
{
  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.settings = {
      "$mod" = "SUPER";

      bind = [
        "$mod, RETURN, exec, ${terminalCmd}"
        # ... more bindings
      ]
      ++ (map (n: "$mod, ${toString n}, workspace, ${toString n}") (range 1 9));
    };
  };
}
```

### Example 3: Using Variables from Configuration

```nix
{ config, lib, pkgs, ... }:

let
  # Define reusable values
  terminal = "${lib.getExe pkgs.kitty}";
  browser = "${lib.getExe pkgs.firefox}";
  launcher = "${lib.getExe pkgs.walker}";

  # Color scheme
  colors = {
    active = "rgba(89b4faff)";
    inactive = "rgba(313244ff)";
  };
in
{
  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      "$terminal" = terminal;
      "$browser" = browser;
      "$launcher" = launcher;

      bind = [
        "$mod, RETURN, exec, $terminal"
        "$mod, B, exec, $browser"
        "$mod, SPACE, exec, $launcher"
      ];

      general = {
        "col.active_border" = colors.active;
        "col.inactive_border" = colors.inactive;
      };
    };
  };
}
```

## Common Patterns

### Conditional Configuration

```nix
settings = {
  monitor = if hasMonitor
    then [ "DP-1,2560x1440@144,0x0,1" ]
    else [ "eDP-1,1920x1080@60,0x0,1" ];

  decoration = lib.mkIf config.isGaming {
    blur.enabled = false;  # Disable blur for gaming
  };
};
```

### Using extraConfig for Complex Rules

When Nix syntax becomes awkward, use `extraConfig`:

```nix
{
  wayland.windowManager.hyprland = {
    settings = {
      # Most config here
    };

    extraConfig = ''
      # Complex rules that are easier in native format
      windowrulev2 = workspace 3 silent,class:^(discord)$,title:^(.*)$

      # Submap definitions
      bind = $mod, R, submap, resize
      submap = resize
      bind = , H, resizeactive, -50 0
      bind = , L, resizeactive, 50 0
      bind = , escape, submap, reset
      submap = reset
    '';
  };
}
```

### Environment-Specific Configuration

```nix
{ config, lib, pkgs, ... }:

let
  isLaptop = config.networking.hostName == "laptop";
  isDesktop = config.networking.hostName == "desktop";
in
{
  wayland.windowManager.hyprland.settings = {
    # Laptop-specific: enable touch gestures
    gestures.workspace_swipe = isLaptop;

    # Desktop-specific: higher refresh rate
    monitor = if isDesktop
      then [ "DP-1,2560x1440@165,0x0,1" ]
      else [ "eDP-1,1920x1080@60,0x0,1" ];
  };
}
```

## Troubleshooting

### Common Issues

#### 1. Configuration Not Applying

Check the generated config:
```bash
cat ~/.config/hypr/hyprland.conf
```

Verify Home Manager generation:
```bash
home-manager generations
```

#### 2. Syntax Errors

Use `nix flake check` to validate:
```bash
nix flake check
```

Test rebuild:
```bash
sudo nixos-rebuild test --flake .#hostname
```

#### 3. Variables Not Working

Variables must be defined before use:
```nix
settings = {
  "$mod" = "SUPER";  # Define first
  bind = [ "$mod, Q, killactive" ];  # Use after
};
```

#### 4. List vs String Confusion

Use lists for repeated keys:
```nix
# Wrong
monitor = "DP-1,2560x1440,0x0,1";
monitor = "HDMI-1,1920x1080,2560x0,1";  # Second overwrites first

# Correct
monitor = [
  "DP-1,2560x1440,0x0,1"
  "HDMI-1,1920x1080,2560x0,1"
];
```

### Debug Commands

```bash
# Check Hyprland version
hyprctl version

# Check current monitors
hyprctl monitors

# Check active window class
hyprctl activewindow

# Reload configuration
hyprctl reload

# Check for errors
journalctl --user -u hyprland-session.target
```

## Additional Resources

- [Hyprland Wiki](https://wiki.hyprland.org)
- [Home Manager Options](https://nix-community.github.io/home-manager/options.xhtml)
- [NixOS Hyprland Wiki](https://wiki.nixos.org/wiki/Hyprland)
- [Hyprland GitHub](https://github.com/hyprwm/Hyprland)

## This Repository's Implementation

The Hyprland configuration in this repository is located at:
- `home/programs/hyprland/` - Main configuration directory
  - `default.nix` - Module options and package setup
  - `hyprland-settings.nix` - Core Hyprland settings
  - `keybindings.nix` - Keyboard and mouse bindings
  - `services.nix` - Hyprland-related services (mako, hyprpaper, hypridle)
  - `waybar.nix` - Waybar status bar configuration
  - `walker.nix` - Walker application launcher

To enable on a host:
```nix
# In hosts/<hostname>/default.nix
{
  imports = [
    ../../home/programs/hyprland
  ];

  my.desktop.hyprland = {
    enable = true;
    monitors = [
      "DP-2,2560x1440@165,0x0,1"
      "HDMI-A-1,1920x1080@60,2560x0,1"
    ];
  };
}
```

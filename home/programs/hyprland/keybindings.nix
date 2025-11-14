{ lib, pkgs, ... }:

with lib;

{
  wayland.windowManager.hyprland.settings = {
    "$mod" = "ALT";

    windowrulev2 = [
      # Flake rebuild terminal on second monitor
      "monitor 1, title:^(flake-rebuild)$"
      "workspace 1 silent, title:^(flake-rebuild)$"
    ];

    bind = [
      # Application launchers
      "$mod, RETURN, exec, ${pkgs.kitty}/bin/kitty"
      "$mod, SPACE, exec, ${pkgs.walker}/bin/walker"
      "$mod, B, exec, ${pkgs.librewolf}/bin/librewolf"
      "$mod, Z, exec, ${pkgs.zed-editor}/bin/zeditor"
      "$mod, T, exec, ${pkgs.kitty}/bin/kitty --class=kitty-floating"

      # Flake rebuild on second screen
      "$mod SHIFT, R, exec, ${pkgs.kitty}/bin/kitty --title flake-rebuild sh -c 'cd /home/ham/nix-config && sudo nixos-rebuild switch --flake .#desk'"

      # Window management
      "$mod, Q, killactive"
      "$mod SHIFT, Q, exit"
      "$mod SHIFT, RETURN, fullscreen, 0"
      "$mod, M, fullscreen, 1"
      "$mod, V, togglefloating"
      "$mod, P, pseudo"
      "$mod, G, togglegroup"

      # Focus movement (Vim-style)
      "$mod, H, movefocus, l"
      "$mod, L, movefocus, r"
      "$mod, K, movefocus, u"
      "$mod, J, movefocus, d"

      # Window movement (Vim-style)
      "$mod SHIFT, H, movewindow, l"
      "$mod SHIFT, L, movewindow, r"
      "$mod SHIFT, K, movewindow, u"
      "$mod SHIFT, J, movewindow, d"

      # Workspace navigation
      "$mod, TAB, workspace, previous"
      "$mod SHIFT, TAB, movetoworkspace, previous"

      # Window resizing (Vim-style with Ctrl)
      "$mod CTRL, H, resizeactive, -50 0"
      "$mod CTRL, L, resizeactive, 50 0"
      "$mod CTRL, K, resizeactive, 0 -50"
      "$mod CTRL, J, resizeactive, 0 50"
    ]
    # Workspace switching (Super + 1-9)
    ++ (map (n: "$mod, ${toString n}, workspace, ${toString n}") (lib.range 1 9))
    # Move to workspace (Super + Shift + 1-9)
    ++ (map (n: "$mod SHIFT, ${toString n}, movetoworkspace, ${toString n}") (lib.range 1 9));

    # Mouse bindings
    bindm = [
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
    ];

    # Repeatable bindings (audio)
    binde = [
      ",XF86AudioRaiseVolume, exec, pamixer -i 5"
      ",XF86AudioLowerVolume, exec, pamixer -d 5"
      ",XF86AudioMute, exec, pamixer -t"
      ",XF86AudioMicMute, exec, pamixer --default-source -t"
    ];

    # Repeatable bindings (brightness)
    bindle = [
      ",XF86MonBrightnessUp, exec, brightnessctl set +5%"
      ",XF86MonBrightnessDown, exec, brightnessctl set 5%-"
    ];
  };
}

{ config, pkgs, ... }:


{
  programs.kitty = {
    enable = true;

    # Font configuration
    font = {
      name = "FiraCode Nerd Font";
      size = 12.0;
    };

    # Shell integration
    shellIntegration = {
      enableZshIntegration = true;
      enableBashIntegration = true;
    };

    # Settings
    settings = {
      # Core functionality
      confirm_os_window_close = 0;
      allow_remote_control = true;
      shell_integration = "enabled";

      # Performance
      repaint_delay = 10;
      input_delay = 3;
      sync_to_monitor = true;

      # Scrollback
      scrollback_lines = 20000;

      # Mouse
      mouse_hide_wait = 3.0;
      copy_on_select = "clipboard";
      strip_trailing_spaces = "smart";

      # URL handling
      detect_urls = true;
      open_url_with = "default";

      # Bell
      enable_audio_bell = false;
    };

    # Key bindings
    keybindings = {
      "ctrl+shift+c" = "copy_to_clipboard";
      "ctrl+shift+v" = "paste_from_clipboard";
      "ctrl+shift+t" = "new_tab";
      "ctrl+shift+w" = "close_tab";
      "ctrl+shift+right" = "next_tab";
      "ctrl+shift+left" = "previous_tab";
      "ctrl+shift+equal" = "increase_font_size";
      "ctrl+shift+minus" = "decrease_font_size";
      "ctrl+shift+backspace" = "restore_font_size";
    };

    # Theme
    themeFile = "gruvbox-dark-hard";
  };
}

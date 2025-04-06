# modules/desktop/virtual-keyboard.nix
{ config, lib, pkgs, ... }:

{
  # Install necessary packages for virtual keyboards
  environment.systemPackages = with pkgs; [
    # On-screen keyboards
    onboard        # GTK-based flexible on-screen keyboard
    florence       # Extensible scalable on-screen keyboard
    
    # Input method frameworks
    fcitx5
    fcitx5-configtool
    fcitx5-gtk
    fcitx5-with-addons
    
    # Diagnostic tools
    wev             # Tool for debugging Wayland input events
    evtest          # Tool for debugging X11/input events
  ];

  # Configure input method framework
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-gtk
      fcitx5-configtool
    ];
  };

  # Configure SDDM for better touch support
  services.displayManager.sddm = {
    enable = true;
    settings = {
      General = {
        InputMethod = "qtvirtualkeyboard"; # Built-in Qt virtual keyboard
      };
    };
  };

  # Enable improved touch support
  services.libinput = {
    enable = true;
    touchpad = {
      tapping = true;
      naturalScrolling = true;
      scrollMethod = "twofinger";
      disableWhileTyping = true;
      additionalOptions = ''
        Option "TappingButtonMap" "lmr"
      '';
    };
  };

  # KDE specific settings (if using KDE)
  services.xserver.desktopManager.plasma6 = lib.mkIf config.services.desktopManager.plasma6.enable {
    # Ensure accessibility features are enabled
    # This ensures the KDE accessibility services that support virtual keyboard 
    # are properly initialized
    enableQt5Integration = true;
  };

  # Automatically start Onboard on login for any desktop environment
  systemd.user.services.onboard = {
    description = "Onboard Virtual Keyboard";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.onboard}/bin/onboard";
      Restart = "on-failure";
    };
  };

  # Enable autostart file for Onboard as fallback
  environment.etc."xdg/autostart/onboard-autostart.desktop" = {
    text = ''
      [Desktop Entry]
      Type=Application
      Name=Onboard Virtual Keyboard
      Exec=${pkgs.onboard}/bin/onboard
      Icon=onboard
      X-GNOME-Autostart-enabled=true
      X-KDE-autostart-after=panel
      X-KDE-StartupNotify=false
      X-KDE-UniqueApplet=true
      NoDisplay=false
      X-GNOME-Autostart-Phase=Applications
      OnlyShowIn=GNOME;XFCE;MATE;X-Cinnamon;KDE;
    '';
    mode = "0644";
  };

  # Ensure XDG paths are properly set up
  environment.sessionVariables = {
    # Ensure fcitx5 is properly recognized by applications
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
    SDL_IM_MODULE = "fcitx";
    GLFW_IM_MODULE = "ibus"; # GLFW doesn't support fcitx directly
  };
}

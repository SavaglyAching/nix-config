# SuperClaude Framework Home Manager module
{ config, lib, pkgs, ... }:

{
  # Install pipx for isolated Python application management
  home.packages = with pkgs; [
    pipx
    python3
    python3Packages.uv  # UV for SuperClaude's Python operations

    # Development tools that work well with SuperClaude
    python3Packages.pytest
    python3Packages.black
    python3Packages.ruff
    python3Packages.mypy

    # Claude Code integration tools
    gemini-cli  # For second opinions and code review
  ];

  # Enable Claude Code with SuperClaude integration
  programs.claude-code.enable = true;
  programs.claude-code.package = pkgs.unstable.claude-code;

  # Shell aliases for SuperClaude workflow
  programs.zsh.shellAliases = {
    # SuperClaude commands
    sc = "superclaude";
    sc-install = "pipx install superclaude && superclaude install";
    sc-update = "pipx upgrade superclaude";
    sc-uninstall = "pipx uninstall superclaude";
    sc-reinstall = "pipx uninstall superclaude && pipx install superclaude && superclaude install";

    # Development workflow (if you have local source)
    sc-dev = "echo 'Use pipx install -e ./SuperClaude_Framework for development mode'";
    sc-test = "echo 'Tests available via: superclaude test or pytest in your project'";
  };

  programs.bash.shellAliases = {
    # SuperClaude commands
    sc = "superclaude";
    sc-install = "pipx install superclaude && superclaude install";
    sc-update = "pipx upgrade superclaude";
    sc-uninstall = "pipx uninstall superclaude";
    sc-reinstall = "pipx uninstall superclaude && pipx install superclaude && superclaude install";

    # Development workflow (if you have local source)
    sc-dev = "echo 'Use pipx install -e ./SuperClaude_Framework for development mode'";
    sc-test = "echo 'Tests available via: superclaude test or pytest in your project'";
  };

  # Environment variables for SuperClaude
  home.sessionVariables = {
    SUPERCLAUDE_HOME = "${config.home.homeDirectory}/.local/share/superclaude";
  };

  # Activation script to install SuperClaude with pipx
  home.activation.installSuperClaude = lib.hm.dag.entryAfter ["writeBoundary"] ''
    # Create SuperClaude directories
    mkdir -p "$HOME/.local/share/superclaude"
    mkdir -p "$HOME/.claude/commands"

    echo "Setting up SuperClaude Framework..."

    # Check if superclaude command is available
    if ! command -v superclaude >/dev/null 2>&1; then
      echo "Installing SuperClaude Framework with pipx..."
      pipx install superclaude

      if [ $? -eq 0 ]; then
        echo "SuperClaude Framework installed successfully"

        # Install Claude Code commands
        echo "Installing Claude Code commands..."
        superclaude install 2>/dev/null || echo "Note: Command installation had minor issues, but framework should work"

        # Mark installation
        touch "$HOME/.local/share/superclaude/.pipx-installed"
        echo "SuperClaude setup complete"
      else
        echo "Error: Failed to install SuperClaude Framework"
        exit 1
      fi
    else
      echo "SuperClaude Framework already installed ($(superclaude --version 2>/dev/null || echo 'version unknown'))"

      # Upgrade if needed (optional - comment out if you don't want auto-upgrades)
      # echo "Checking for updates..."
      # pipx upgrade superclaude

      # Ensure commands are installed
      if [ ! -d "$HOME/.claude/commands" ] || [ -z "$(ls -A $HOME/.claude/commands 2>/dev/null)" ]; then
        echo "Installing Claude Code commands..."
        superclaude install 2>/dev/null || echo "Note: Command installation had minor issues"
      fi
    fi

    # Set proper permissions
    chmod -R 755 "$HOME/.claude/" 2>/dev/null || true
    chmod -R 755 "$HOME/.local/share/superclaude" 2>/dev/null || true

    echo "SuperClaude Framework ready"
    echo "Available commands:"
    echo "  sc          - Run superclaude"
    echo "  sc-install  - Install or update SuperClaude"
    echo "  sc-update   - Upgrade SuperClaude"
    echo "  superclaude  - Direct access to SuperClaude CLI"
  '';

  # Optional cleanup for pipx-based installation
  home.activation.cleanupSuperClaude = lib.hm.dag.entryBefore ["installSuperClaude"] ''
    # Clean up any old installations if they exist
    if [ -f "$HOME/.local/share/superclaude/.installed" ] && [ ! -f "$HOME/.local/share/superclaude/.pipx-installed" ]; then
      echo "Cleaning up old SuperClaude installation..."
      rm -rf "$HOME/.local/share/superclaude/.installed" 2>/dev/null || true
    fi
  '';

  # Claude Code settings optimized for SuperClaude
  programs.claude-code.settings = {
    # Enable MCP servers that work well with SuperClaude
    mcp = {
      nixos = { enabled = true; };
      serena = { enabled = true; };
    };

    # Output style for development
    output = {
      style = "minimal";
      showLineNumbers = true;
    };

    # Auto-save context for better SuperClaude integration
    context = {
      autoSave = true;
      maxHistory = 1000;
    };
  };

  # Optional systemd user service for ensuring SuperClaude environment
  systemd.user.services.superclaude-env = {
    Unit = {
      Description = "SuperClaude Framework Environment Setup";
      After = [ "network.target" ];
    };
    Service = {
      Type = "oneshot";
      RemainAfterExit = "yes";
      ExecStart = "${pkgs.bash}/bin/bash -c 'mkdir -p ${config.home.homeDirectory}/.local/share/superclaude ${config.home.homeDirectory}/.cache/uv'";
    };
    WantedBy = [ "default.target" ];
  };

  # Module configuration options
  options.programs.superclaude = {
    enable = lib.mkEnableOption "SuperClaude Framework installed via pipx";

    autoInstall = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to automatically install SuperClaude during Home Manager activation";
    };

    autoUpdate = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to automatically upgrade SuperClaude during activation";
    };

    version = lib.mkOption {
      type = lib.types.str;
      default = "latest";
      description = "Version of SuperClaude to install (default: latest from PyPI)";
    };

    developmentMode = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable development aliases for local SuperClaude source development";
    };
  };
}
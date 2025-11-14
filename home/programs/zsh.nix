{ config, pkgs, lib, ... }:

{

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
    # ls replacements with eza
    ls = "eza --icons=always --group-directories-first";
    ll = "eza -l --icons=always --group-directories-first";
    la = "eza -a --icons=always --group-directories-first";
    lla = "eza -la --icons=always --group-directories-first";
    lt = "eza --tree --icons=always --group-directories-first";

    # NixOS management
    # fr = "sudo nixos-rebuild switch --flake /home/ham/nix-config#$(hostname)";
    fr = "nh os switch /home/ham/nix-config --hostname $(hostname)";
    nm = "cd ~/nix-config/";
    fc = "nix flake check /home/ham/nix-config/";
    fu = "nix flake update ~/nix-config";
    nsp = "nix-shell -p ";

    tsr = "sudo tailscale up --ssh --reset";
    tst = "sudo tailscale up --exit-node \"ca-tor-wg-001.mullvad.ts.net\" --ssh";

    # Editor shortcuts
    m = "micro";
    x = "exit";
    s = "source ~/.zshrc";
    y = "yazi";

    #
    cc = "claude";

    # Media and networking
    yt = "yt-dlp --retries infinite --fragment-retries infinite --socket-timeout 90 --no-part --downloader ffmpeg --hls-use-mpegts";
    wud = "wakeonlan d8:43:ae:50:aa:72";
    rmv = "rsync -avz --checksum --progress --remove-source-files";
    mvstreams = "mkdir -p ~/streams && find . -maxdepth 1 -type f \\( -name '*.mp4' -o -name '*.flv' \\) -exec mv -v {} ~/streams/ \\;";

    # SOPS shortcuts
    sops-edit = "sops";
    sops-encrypt = "sops -e";
    sops-decrypt = "sops -d";
    };

    history = {
      size = 10000;
      save = 10000;
      path = "${config.home.homeDirectory}/.zsh_history";
      ignoreDups = true;
      ignoreSpace = true;
      share = true;
    };

    # Directory navigation
    autocd = true;

    # Configure oh-my-zsh tmux plugin before oh-my-zsh loads (runs before completion initialization)
    initContent = lib.mkMerge [
      (lib.mkOrder 550 ''
        export ZSH_TMUX_AUTOSTART=false
        export ZSH_TMUX_AUTOSTART_ONCE=false
        export ZSH_TMUX_AUTOCONNECT=false
        export ZSH_TMUX_AUTOQUIT=false
      '')

      # Default priority initialization
      ''
        # Set DISPLAY for XWayland if not set (needed for Steam and X11 apps on Wayland)
        if [ -z "$DISPLAY" ] && [ "$XDG_SESSION_TYPE" = "wayland" ]; then
          export DISPLAY=:0
        fi

        # Source SOPS environment variables for API keys
        if [ -f /run/secrets/openrouter.env ]; then
          source /run/secrets/openrouter.env
        fi

        # Moose greeting
        fortune | cowsay -r | lolcat

        # VCS info in prompt
        autoload -Uz vcs_info
        precmd() { vcs_info }
        zstyle ':vcs_info:git:*' formats '%b '
        setopt PROMPT_SUBST
        PROMPT='%F{green}%n@%m%f:%F{blue}%~%f %F{red}''${vcs_info_msg_0_}%f$ '

        # Enhanced directory navigation
        setopt AUTO_PUSHD
        setopt PUSHD_IGNORE_DUPS
        setopt PUSHD_SILENT

        # Custom functions
        mkcd() {
            mkdir -p "$1" && cd "$1"
        }

        # Rebuild with Gemini analysis on failure
        frg() {
            local output_file=$(mktemp)
            if ! nh os switch /home/ham/nix-config --hostname $(hostname) 2>&1 | tee "$output_file"; then
                echo -e "\n\nRebuild failed. Analyzing with Gemini...\n"
                cat "$output_file" | gemini -p "Analyze this NixOS rebuild failure and provide actionable solutions:"
            fi
            rm -f "$output_file"
        }

        # Load nix-specific configurations if available
        if [[ -f ~/.nix-profile/etc/profile.d/nix.sh ]]; then
            source ~/.nix-profile/etc/profile.d/nix.sh
        fi
      ''
    ];

    # Oh My Zsh integration
    oh-my-zsh = {
      enable = true;
      theme = "agnoster";
      plugins = [
        "git"
        "sudo"
        "history"
        "command-not-found"
        "zsh-interactive-cd"
        "tmux"
        "git-auto-fetch"
        "tailscale"
      ];
    };
  };
}

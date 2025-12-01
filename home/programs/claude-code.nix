{ config, pkgs, lib, ... }:

{
  programs.claude-code = {
    enable = true;

    settings = {
      statusLine = {
        type = "command";
        command = ''
          # User and hostname in green (matches ZSH prompt)
          printf '\\033[32m%s@%s\\033[0m:' "$(whoami)" "$(hostname)"

          # Current directory in blue, with ~ substitution
          printf '\\033[34m%s\\033[0m' "$(pwd | sed "s|^$HOME|~|")"

          # Git branch in red if available (matches ZSH vcs_info)
          if branch=$(git branch --show-current 2>/dev/null); then
            printf ' \\033[31m%s\\033[0m' "$branch"
          fi

          echo
        '';
      };
    };

    mcpServers = {
      # NixOS MCP Server - for package search, options, and Home Manager
      nixos = {
        type = "stdio";
        command = "nix";
        args = [
          "run"
          "github:utensils/mcp-nixos"
          "--"
        ];
        env = {};
      };

      # Zen MCP Server - for AI model access via OpenRouter
      # zen = {
      #   type = "stdio";
      #   command = "uvx";
#:)
      #   args = [
      #     "--from"
      #     "git+https://github.com/BeehiveInnovations/zen-mcp-server.git"
      #     "zen-mcp-server"
      #   ];
      #   # Using environment variable that should be set from SOPS secret
      #   # Make sure to export OPENROUTER_API_KEY in your shell
      #   env = {
      #     OPENROUTER_API_KEY = "$OPENROUTER_API_KEY";
      #   };
      # };

      # Serena MCP Server - for intelligent code navigation and editing
      serena = {
        type = "stdio";
        command = "nix";
        args = [
          "run"
          "github:oraios/serena"
          "--"
          "start-mcp-server"
          "--transport"
          "stdio"
          "--context"
          "ide-assistant"
          "--enable-web-dashboard"
          "false"
        ];
        env = {};
      };

      # Context7 MCP Server - for library documentation lookup
      context7 = {
        type = "stdio";
        command = "npx";
        args = [
          "-y"
          "@upstash/context7-mcp"
        ];
        env = {};
      };

      # Perplexity MCP Server - for AI-powered web search and research
      # Note: Requires PERPLEXITY_API_KEY environment variable to be set in your shell
      perplexity = {
        type = "stdio";
        command = "npx";
        args = [
          "-y"
          "perplexity-mcp"
        ];
      };

      # Sequential Thinking MCP Server - for step-by-step reasoning
      sequential-thinking = {
        type = "stdio";
        command = "npx";
        args = [
          "-y"
          "@modelcontextprotocol/server-sequential-thinking"
        ];
      };
    };
  };
}

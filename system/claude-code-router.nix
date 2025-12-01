{
  config,
  lib,
  pkgs,
  ai-tools,
  ...
}:

{
  # SOPS template to generate claude-code-router config with API keys
  sops.templates."claude-code-router-config.json" = {
    content = builtins.toJSON {
      LOG = true;
      LOG_LEVEL = "debug";
      CLAUDE_PATH = "";
      HOST = "127.0.0.1";
      PORT = 3456;
      APIKEY = "sk-ccr-secret-key";
      API_TIMEOUT_MS = "600000";
      PROXY_URL = "";
      transformers = [ ];
      Providers = [
        {
          name = "GLM";
          api_base_url = "https://api.z.ai/api/coding/paas/v4/chat/completions";
          api_key = config.sops.placeholder.ZAI_API_KEY;
          models = [
            "GLM-4.6"
          ];
        }
        {
          name = "Openrouter";
          api_base_url = "https://openrouter.ai/api/v1/chat/completions";
          api_key = config.sops.placeholder.OPENROUTER_API_KEY;
          models = [
            "x-ai/grok-4.1-fast"
            "moonshotai/kimi-k2-thinking"
          ];
          transformer = {
            use = [
              "openrouter"
            ];
          };
        }
      ];
      StatusLine = {
        enabled = false;
        currentStyle = "default";
        default = {
          modules = [
            {
              type = "model";
              icon = "🤖";
              text = "{{model}}";
              color = "bright_yellow";
            }
            {
              type = "usage";
              icon = "📊";
              text = "{{inputTokens}} → {{outputTokens}}";
              color = "bright_magenta";
            }
          ];
        };
        powerline = {
          modules = [ ];
        };
      };
      Router = {
        default = "Openrouter,x-ai/grok-4.1-fast";
        background = "Openrouter,x-ai/grok-4.1-fast";
        think = "Openrouter,x-ai/grok-4.1-fast";
        longContext = "Openrouter,x-ai/grok-4.1-fast";
        longContextThreshold = 60000;
        webSearch = "Openrouter,x-ai/grok-4.1-fast";
        image = "Openrouter,x-ai/grok-4.1-fast";
      };
      CUSTOM_ROUTER_PATH = "";
    };
    path = "/home/ham/.claude-code-router/config.json";
    owner = "ham";
    group = "users";
    mode = "0600";
  };

  # Ensure the directory exists
  systemd.tmpfiles.rules = [
    "d /home/ham/.claude-code-router 0755 ham users -"
  ];

  # Systemd user service for claude-code-router
  systemd.user.services.claude-code-router = {
    description = "Claude Code Router";
    wantedBy = [ "default.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      ExecStart = "${ai-tools.claude-code-router}/bin/ccr start";
      Restart = "always";
      RestartSec = 5;
      Environment = "HOME=/home/ham";
    };
  };
}

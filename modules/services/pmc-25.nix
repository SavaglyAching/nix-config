{ config, ... }:

{
  # Enable and configure two Paper Minecraft servers
  services.papermc = {
    # Server 1 - Survival mode
    "pmc-main" = {
      enable = true;
      serverProperties = {
        server-port = 25565;
        gamemode = "survival";
        motd = "Survival Paper Server";
      };
      jvmOpts = "-Xms1G -Xmx2G";
      eula = true;
    };

    # Server 2 - Creative mode
    "pmc-dev" = {
      enable = true;
      serverProperties = {
        server-port = 25566;
        gamemode = "creative";
        motd = "Creative Paper Server";
      };
      jvmOpts = "-Xms1G -Xmx2G";
      eula = true;
    };
  };

  # Open firewall ports for both servers
  networking.firewall.allowedTCPPorts = [ 25565 25566 ];
}

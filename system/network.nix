{
  config,
  lib,
  pkgs,
  ...
}:

{

  services.resolved = {
    enable = true;

    # Enable DNS-over-TLS (DoT)
    # "opportunistic" will try to use DoT and fall back to unencrypted DNS if not supported.
    # Set to "true" or "yes" to enforce DoT.
    dnsovertls = "true";

    # Enable DNSSEC validation
    # "allow-downgrade" will perform validation only if the upstream server supports it.
    dnssec = "allow-downgrade";
  };
  networking = {

    nameservers = [
      "194.242.2.5"
      "100.100.100.100"
    ];

    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 ]; # Allow SSH
      # allowedUDPPorts = [ 41641 ]; # Tailscale port - This is not needed as tailscale0 is a trusted interface.
      allowPing = false;
      trustedInterfaces = [ "tailscale0" ]; # Trust tailscale interface
    };
  };
}

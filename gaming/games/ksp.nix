{ config, pkgs, ... }:

{
  # KSP and CKAN mod manager
  environment.systemPackages = with pkgs; [
    # Kerbal Space Program mod manager
    ckan

  ];

}
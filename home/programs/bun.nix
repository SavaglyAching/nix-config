{ config, pkgs, ... }:

{
  # Bun uses ~/.bun/bin for global binaries by default
  # Add it to PATH
  home.sessionVariables = {
    PATH = "$HOME/.bun/bin:$PATH";
  };

  # Create a symlink from bun to node for compatibility with packages
  # that have hardcoded #!/usr/bin/env node shebangs
  home.file.".local/bin/node" = {
    source = "${pkgs.bun}/bin/bun";
    executable = true;
  };

  # Ensure .local/bin is in PATH
  home.sessionPath = [
    "$HOME/.local/bin"
  ];
}

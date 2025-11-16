# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Communication Style
Claude Code adopts the Linus Torvalds approach when working in this repository:
- **Direct criticism**: If code is bad, say it's bad and why
- **Zero patience for bullshit**: Marketing speak, unnecessary abstraction, or over-engineering gets called out
- **Pragmatic over ideological**: What matters is whether it works, not whether it's "pure" or "elegant"
- **Technical accuracy first**: No sugarcoating, no emotional validation
- **Efficient communication**: Short, precise, to the point

## Project Overview
NixOS configuration using Nix Flakes, supporting multiple machines (desk, rica, mini, surface) with shared modular components. Includes desktop environments, gaming, containerized services, and development tools.

## Repository Structure
- **flake.nix**: Main flake configuration with host definitions and common modules
- **hosts/**: Per-host configurations (desk, rica, mini, surface)
- **system/**: Core system modules (packages, users, boot, network, nix settings, btrfs, sops)
- **home/**: Home Manager user configurations (programs: git, zsh, tmux, ssh, helix, kitty, neovim)
- **desktop/**: Desktop environment modules (kde.nix, gnome.nix, xfce.nix)
- **services/**: Service modules (podman, ssh, tailscale, samba, ollama, remote-desktop)
- **services/containers/**: Container service definitions using virtualisation.oci-containers
- **gaming/**: Gaming configuration (gaming.nix)
- **hardware/**: Hardware-specific modules (amd.nix)
- **secrets.yaml**: SOPS encrypted secrets (AGE encryption)
- **docs/**: Documentation and migration guides

## Hosts Overview
- **desk**: Desktop workstation (KDE, gaming, Podman, remote builder, BTRFS, remote unlock, AMD GPU, Samba client+server)
- **rica**: File server (Samba, Podman containers, remote desktop, BTRFS, Caddy reverse proxy, audiobookshelf)
- **mini**: Deployment manager (Colmena, Podman containers - karakeep, remote desktop, borgbackup, Forgejo)
- **surface**: Microsoft Surface Pro (GNOME, remote builder, Waydroid, nixos-hardware integration)

## Key Commands

### System Operations
```bash
# Build and switch configuration
sudo nixos-rebuild switch --flake .#<hostname>

# Test configuration without switching
sudo nixos-rebuild test --flake .#<hostname>

# Update flake inputs
nix flake update

# Check flake
nix flake check
```

### Development Workflow
```bash
# Enter development shell
nix develop

# Format nix files
nix fmt

# Run garbage collection
sudo nix-collect-garbage -d
```

### Colmena Deployment (from mini)
```bash
# Deploy to all hosts
colmena apply

# Deploy to specific host(s)
colmena apply --on desk
colmena apply --on desk,rica

# Build without deploying
colmena build

# Deploy locally (on the current host)
colmena apply-local --sudo

# Check what will be deployed
colmena eval
```

**Colmena Configuration**:
- Deploys via SSH as user `ham` (uses sudo for activation)
- Uses Tailscale hostnames: desk, rica, mini, surface
- Shares same modules as nixosConfigurations
- Controlled from mini host (deployment manager)

### Package Search with nix-search-tv
```bash
# Basic fuzzy search for packages
nix-search-tv print | fzf --preview 'nix-search-tv preview {}' --scheme history

# Recommended alias for easy access
alias ns="nix-search-tv print | fzf --preview 'nix-search-tv preview {}' --scheme history"

# Direct search (outputs to terminal)
nix-search-tv print | grep firefox

# Preview package details
nix-search-tv preview firefox
```

**nix-search-tv Features**:
- **Fuzzy search**: Integrates with fzf for interactive package discovery
- **Multi-registry support**: Searches Nixpkgs, Home Manager, NixOS options, Darwin, NUR
- **Live preview**: Shows package descriptions, versions, and details
- **Fast indexing**: Updates package database automatically
- **History sorting**: Use `--scheme history` with fzf for better search experience

**Usage Tips**:
- Use `ns` alias for quick package searches
- Press Tab in fzf to select multiple packages
- Use Ctrl+C to copy package names
- Preview shows installation commands and package metadata

### AI Assistant Workflow
```bash
# Use Gemini for code review and second opinions
gemini -p "Review this code for best practices and potential issues: [code]"

# Ask Gemini questions about code or configuration
gemini -p "How can I optimize this NixOS configuration?"

# Get alternative perspectives on implementation approaches
gemini -p "What are the pros and cons of this approach vs alternatives?"
```

**Best Practice**: Always use Gemini CLI (`gemini -p`) for code review as a second opinion, especially for:
- Configuration changes
- New module implementations
- Complex system modifications
- Security-sensitive configurations

### Claude Code Specialized Agents
Claude Code includes specialized agents for complex tasks:

**Available Agents**:
- **general-purpose**: Multi-step research, code search, and complex task execution
- **statusline-setup**: Configure Claude Code status line settings
- **output-style-setup**: Create custom Claude Code output styles
- **nixos-expert**: Expert guidance on NixOS administration, configuration, and troubleshooting
- **gemini-consultant**: Second opinions, code review, and high token count analysis

**Usage Examples**:
```bash
# For complex NixOS issues
"I'm getting circular dependency errors with my custom service module"

# For code reviews and validation
"Review this NixOS module for best practices"

# For multi-step tasks and research
"Search the codebase and implement a new container service"
```

**When to Use Agents**:
- Complex multi-step tasks requiring autonomous execution
- NixOS configuration problems needing expert knowledge
- Code reviews requiring alternative AI perspectives
- Large analysis tasks that might exceed token limits
- Research tasks spanning multiple files and concepts

### Serena MCP Server Integration
Claude Code includes the Serena MCP server for intelligent codebase navigation and editing. Available features:

**Code Navigation**:
- **find_symbol**: Find code symbols (classes, functions, methods) by name path with substring matching
- **get_symbols_overview**: Get high-level overview of symbols in a file
- **find_referencing_symbols**: Find all references to a specific symbol
- **search_for_pattern**: Flexible regex pattern search across the codebase

**Code Editing**:
- **replace_symbol_body**: Replace entire symbol body (functions, classes, methods)
- **insert_after_symbol**: Insert code after a symbol definition
- **insert_before_symbol**: Insert code before a symbol definition

**Project Management**:
- **list_dir**: List files and directories (with recursive option)
- **find_file**: Find files by name or pattern
- **write_memory**: Store project information for future sessions
- **read_memory**: Retrieve stored project information

**Usage Philosophy**:
- Use symbolic tools first (find_symbol, get_symbols_overview) before reading entire files
- Read only necessary code portions for the task
- Use search_for_pattern for flexible content discovery
- Prefer symbolic editing (replace_symbol_body) over manual edits when possible

### NixOS MCP Server Integration
Claude Code includes the NixOS MCP server for real-time access to NixOS ecosystem data. Available commands:

```bash
# Search NixOS packages and options
"Search for firefox package in NixOS"
"Find nvidia configuration options"

# Get detailed package information
"Show details for the firefox package"
"Get information about services.tailscale.enable option"

# Search Home Manager options
"Search for zsh configuration in Home Manager"
"Find terminal-related Home Manager options"

# Get package version history
"Show version history for nodejs package"
"Find specific Python 3.9 version with commit hash"

# Browse configuration categories
"List all Home Manager categories"
"Show Darwin/macOS configuration options"
```

**Available MCP Tools**:
- **nixos_search**: Search packages, options, or programs across NixOS channels
- **nixos_info**: Get detailed information about specific packages or options
- **home_manager_search**: Search user configuration options in Home Manager
- **nixhub_package_versions**: Get package version history with commit hashes
- **darwin_search**: Search macOS/Darwin configuration options
- **nixos_flakes_search**: Search community flakes ecosystem

**Usage Examples**:
- "Search for Docker packages in NixOS stable"
- "Show me Home Manager options for configuring Git"
- "Find the commit hash for Python 3.11.8"
- "What are the available KDE configuration options?"

## Module Categories

### System Modules (/system/)
- **packages.nix**: System-wide packages (claude-code, development tools, media tools)
- **users.nix**: User account configuration
- **boot.nix**: Boot loader and kernel configuration
- **network.nix**: Network settings
- **nix.nix**: Nix daemon and experimental features
- **btrfs.nix**: BTRFS filesystem configuration  
- **remote-builder.nix**: Remote build configuration
- **sops.nix**: SOPS secrets management

### Desktop Modules (/desktop/)
- **kde.nix**: KDE Plasma desktop environment
- **gnome.nix**: GNOME desktop environment  
- **xfce.nix**: XFCE desktop environment

### Service Modules (/services/)
- **podman.nix**: Podman containerization (OCI container backend)
- **ssh.nix**: SSH server configuration
- **tailscale.nix**: Tailscale VPN
- **samba-client.nix / samba-server.nix**: Samba file sharing
- **ollama.nix**: Ollama AI model server
- **remote-desktop.nix**: Remote desktop access (RDP/RustDesk)

### Gaming (/gaming/)
- **gaming.nix**: Steam and gaming tools

### Container Services (/services/containers/)
Container services use `virtualisation.oci-containers.containers` with Podman backend:
- **karakeep.nix**: Karakeep container service
- **homepage.nix**: Homepage dashboard container
- **audiobookshelf.nix**: Audiobook and podcast server with Caddy reverse proxy
- **claude-code-proxy.nix**: Claude Code proxy container
- **template.nix**: Template for new container services
- **readme.md**: Examples and documentation for container configuration

## Important Packages

### System Packages (system/packages.nix)
System-wide utilities available to all users:
- **Core utilities**: git, curl, wget, htop, btop, tree, unzip, networkmanager
- **AI tools**: claude-code (with MCP servers: nixos, serena)
- **Development**: python3, nodejs, cargo
- **System tools**: stow, age, sops, tmux, nix-search-tv
- **Media tools**: ffmpeg

### User Packages (home/default.nix)
User-specific tools via Home Manager:
- **Shell tools**: zoxide, fzf, fd, ripgrep, bat, yazi, fastfetch
- **Development**: aider-chat, gemini-cli, lazygit, lazydocker, gitui, podman-tui, zed-editor
- **Terminal**: micro, mc, warp-terminal, tmux
- **Applications**: keepassxc
- **Media**: yt-dlp, gallery-dl, instaloader, spotdl

## Adding New Hosts
1. Copy template: `cp -r hosts/template hosts/new-hostname`
2. Generate hardware config: `nixos-generate-config --root /mnt`
3. Copy hardware-configuration.nix to new host directory
4. Edit default.nix to customize modules and hostname
5. Add to flake.nix nixosConfigurations in the `nixosConfigs` attrset:
   ```nix
   "hostname" = nixpkgs.lib.nixosSystem {
     inherit system specialArgs;
     modules = [ ./hosts/hostname ] ++ commonModules;
   };
   ```

## Adding Container Services
1. Copy template: `cp services/containers/template.nix services/containers/service-name.nix`
2. Edit service-name.nix with your container configuration
3. Import in host's default.nix: `../../services/containers/service-name.nix`
4. Container format uses `virtualisation.oci-containers.containers.<name>` with:
   - `image`: Docker image name
   - `autoStart`: Whether to start on boot
   - `ports`: Port mappings (format: "host:container")
   - `environment`: Environment variables as attribute set
   - `volumes`: Volume mounts as list of strings
5. See `services/containers/readme.md` for examples

## Secrets Management
Uses SOPS-nix with AGE encryption for secure secrets management. Key features:
- **secrets.yaml**: Encrypted with 4 AGE recipients for redundancy
- **Secrets include**: API keys (OpenRouter, Gemini), SMB credentials, network IPs, SSH keys
- **Runtime decryption**: Secrets are decrypted at system activation
- **Proper permissions**: All secrets use 0400 permissions with root ownership

**IMPORTANT**: SSH keys and sensitive data should be in SOPS secrets, not hardcoded in configuration files.

## User Configuration
User configurations are declaratively managed with Home Manager:
- **Integration**: Home Manager configured via `system/home-manager.nix` and loaded in all hosts through `commonModules`
- **User config**: `home/default.nix` imports program configs (git, zsh, tmux, ssh, helix, kitty, neovim) and defines user packages
- **Common settings**: `home/users/common.nix` contains shared configuration for all hosts
- **Program configs**: Individual programs configured in `home/programs/` (git.nix, zsh.nix, etc.)
- **State version**: Currently 24.05
- **Legacy dotfiles**: `~/.dotfiles` preserved for reference but no longer actively managed

## Network Configuration
- Tailscale for VPN connectivity
- NetworkManager for connection management
- Wake-on-LAN support on desktop
- SSH with key-based authentication

## Special Features
- Remote unlock via SSH (nixos-desk)
- BTRFS snapshots and subvolumes
- Gaming optimizations (Steam, performance)
- Media tools (yt-dlp, gallery-dl, ffmpeg)
- Development environment with Python, Node.js, Git tools

## Recent Changes

### Home Manager Migration (Commit c77bf1f)
The configuration recently migrated from GNU Stow-managed dotfiles to declarative Home Manager:
- **Before**: Dotfiles in `~/.dotfiles` managed with `stow` command
- **After**: Declarative configs in `home/` directory with Home Manager
- **Migration guide**: See `docs/HOME_MANAGER_MIGRATION.md` for complete details
- **Programs migrated**: git, zsh, tmux, ssh, plus new: helix, kitty, neovim, nh
- **User packages**: Moved from system packages to Home Manager (aider-chat, lazygit, zoxide, etc.)

### Serena MCP Integration (Commit c43cccd)
Added Serena MCP server for intelligent code navigation:
- **Configuration**: `.mcp.json` in repository root
- **Capabilities**: Symbolic code search, editing, project memory management
- **Philosophy**: Read minimal code using symbolic tools before full file reads

### Container Services Evolution
Recent container additions:
- **audiobookshelf** (Commit d46c8cf): Audiobook/podcast server with Caddy reverse proxy at audiobooks.bloood.ca
- **claude-code-proxy**: Proxy container for Claude Code
- All containers use Podman backend (`virtualisation.oci-containers.backend = "podman"`)

## Architecture Notes

### Flake Structure
The flake uses a consistent pattern with:
- **specialArgs**: Provides `unstable` (nixpkgs) and `stable` (nixpkgs-stable) to all modules
- **commonModules**: Applied to all hosts, includes sops-nix, home-manager, and home-manager integration
- **nixosConfigs**: Simple attrset mapping hostnames to nixosSystem configurations
- All hosts use x86_64-linux, share common modules, and import their respective host directory

### Module Organization Philosophy
- **system/**: System-level configuration (boot, networking, users, packages, nix daemon)
- **home/**: User-level configuration via Home Manager (shell, git, editors, personal tools)
- **services/**: System services (podman, ssh, tailscale, samba, remote desktop)
- **desktop/**: Desktop environment configurations
- **hosts/**: Per-host imports and hardware-specific settings

### Home Manager Integration
- Configured in `system/home-manager.nix` with `useGlobalPkgs = true` and `useUserPackages = true`
- Single user "ham" configured via `home/default.nix`
- Programs like zsh, git, tmux, ssh, helix, kitty configured declaratively in `home/programs/`

## Known Issues & Technical Debt

### Critical Issues
- **SSH keys hardcoded** in `hosts/desk/default.nix:32-33` - should use SOPS secrets (see docs/HOME_MANAGER_MIGRATION.md Step 0)

### Organizational Issues
- **Commented imports**: Several host configs contain commented module imports (e.g., `hosts/desk/default.nix:12,13,14,20`)
- **Import path inconsistencies**: Some hosts use different relative path styles for importing modules

### Recommendations
1. Migrate hardcoded SSH keys to SOPS secrets (critical security issue)
2. Clean up commented/unused imports in host configs
3. Consider standardizing module import paths across hosts

## Working with This Codebase

### Before Making Changes
1. **Check git status**: `git status` to see current state
2. **Validate flake**: `nix flake check` to ensure configuration is valid
3. **Test first**: Use `sudo nixos-rebuild test --flake .#hostname` before committing

### When Adding New Modules
1. Place in appropriate directory (system/, services/, desktop/, etc.)
2. Import in relevant host's `default.nix`
3. Test with `nixos-rebuild test` first
4. Use Gemini CLI for code review: `gemini -p "Review this module for best practices"`

### When Editing Home Manager Configs
1. Edit files in `home/programs/` or `home/default.nix`
2. Changes apply to all hosts (single user "ham")
3. Test with `sudo nixos-rebuild test --flake .#hostname`
4. Home Manager changes are user-level but require system rebuild

### When Adding Secrets
1. Edit `secrets.yaml` with: `sops secrets.yaml`
2. Add SOPS secret declarations in appropriate module (usually `system/sops.nix` or host-specific)
3. Secrets available at runtime in `/run/secrets/`
4. Never commit unencrypted secrets to repository

### Using MCP Tools Effectively
- **Serena**: Use `find_symbol` and `get_symbols_overview` before reading entire files
- **NixOS**: Use `nixos_search` and `home_manager_search` for discovering options
- **nixhub**: Use `nixhub_package_versions` to find specific package versions with commit hashes

## Troubleshooting
- Check system logs: `journalctl -xe`
- Rebuild with verbose output: `sudo nixos-rebuild switch --flake .#hostname --show-trace`
- Test configuration: `sudo nixos-rebuild test --flake .#hostname`
- Rollback: Select previous generation in boot menu or `sudo nixos-rebuild switch --rollback`
- Validate flake: `nix flake check`
- Container logs: `podman logs <container-name>` or use `lazydocker` TUI
- Home Manager issues: Check `~/.local/state/home-manager/gcroots/current-home/home-path`
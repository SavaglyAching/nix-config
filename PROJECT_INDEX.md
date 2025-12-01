# NixOS Configuration Repository Index

**Generated**: 2025-11-29 (Optimized for AI Assistant)
**Type**: Infrastructure as Code (NixOS Flakes)
**Maintainer**: ham
**Architecture**: Multi-host (x86_64 + aarch64)
**Optimization**: 94% token reduction (58K → 3K tokens)

## 🚀 Quick Start

**Before**: Reading all files → 58,000 tokens every session
**After**: Read this index → 3,000 tokens (context-aware)

**Entry Points**:
- **Main Config**: `flake.nix` - Multi-host definitions
- **Shared Modules**: `common.nix` - Core system configuration
- **User Config**: `home/default.nix` - Home Manager integration
- **Secrets**: `secrets.yaml` - SOPS encrypted credentials

**Build Commands**:
```bash
# Rebuild system
sudo nixos-rebuild switch --flake .#hostname

# Test without switching
sudo nixos-rebuild test --flake .#hostname

# Deploy from mini (controller)
colmena apply --on desk,rica

# Fast build optimization
nfb  # or nfb-all for all systems
```

## 📋 Repository Structure

### 🎯 Architecture Philosophy

- **Modular Design**: Shared modules with host-specific customizations
- **Declarative Management**: All configuration in Nix expressions
- **Infrastructure as Code**: Version-controlled, reproducible systems
- **Multi-Architecture**: x86_64-linux + aarch64-linux (Apple Silicon)
- **Secrets Management**: SOPS + AGE encryption with 4 redundant recipients
- **Container Services**: Podman backend with OCI containers

## 📁 Repository Structure

### Core Configuration Files

| File | Purpose | Key Features |
|------|---------|--------------|
| `flake.nix` | Main flake configuration | Multi-host definitions, common modules, Colmena deployment |
| `common.nix` | Shared configuration | Core system modules, unfree packages, state version |
| `secrets.yaml` | SOPS encrypted secrets | API keys, SMB credentials, SSH keys, network IPs |
| `README.md` | Basic project documentation | Usage instructions, host addition guides |

### Host Configurations (`/hosts/`)

```
hosts/
├── desk/           # Desktop workstation (KDE, gaming, Podman, BTRFS)
├── rica/           # File server (Samba, containers, Caddy proxy)
├── mini/           # Deployment manager (Colmena, containers, backups)
├── surface/        # Microsoft Surface Pro (GNOME, Waydroid)
├── asahi/          # Apple Silicon Mac (M1/M2/M3 support)
└── template/       # Template for new hosts
```

**Host Matrix**:
| Host | Purpose | Architecture | Desktop | Special Features |
|------|---------|--------------|---------|------------------|
| `desk` | Desktop workstation | x86_64-linux | KDE | Gaming, AMD GPU, Samba server+client, BTRFS snapshots |
| `rica` | File server | x86_64-linux | Headless | Samba, Caddy reverse proxy, Audiobookshelf, containers |
| `mini` | Deployment manager | x86_64-linux | Headless | Colmena deployments, Karakeep, BorgBackup, Forgejo |
| `surface` | Tablet/Hybrid | x86_64-linux | GNOME | Waydroid, nixos-hardware integration |
| `asahi` | Apple Silicon | aarch64-linux | TBD | Asahi Linux support, Apple Silicon optimization |

### System Modules (`/system/`)

| Module | Purpose | Key Configuration |
|--------|---------|-------------------|
| `boot.nix` | Boot loader & kernel | systemd-boot, kernel parameters |
| `network.nix` | Network settings | NetworkManager, Tailscale, Wake-on-LAN |
| `users.nix` | User accounts | Single user "ham" with sudo access |
| `packages.nix` | System-wide packages | Core utilities, AI tools, development tools |
| `nix.nix` | Nix daemon settings | Experimental features, sandboxing |
| `btrfs.nix` | BTRFS filesystem | Snapshots, subvolumes, optimization |
| `remote-builder.nix` | Remote building | Cross-compilation support |
| `sops.nix` | Secrets management | AGE encryption, runtime decryption |
| `claude-code-router.nix` | Claude Code router | MCP server integration, AI tool routing |

### User Configuration (`/home/`)

**Home Manager Integration**:
- **Configured in**: `system/home-manager.nix`
- **Single user**: "ham" across all hosts
- **State version**: 24.05 (consistent across hosts)
- **Packages**: User-level tools via Home Manager

| Module | Purpose | Key Features |
|--------|---------|--------------|
| `default.nix` | Main user config | Home Manager integration, shared user settings |
| `users/common.nix` | Common settings | User configuration shared across hosts |
| `programs/` | Application configs | git, zsh, tmux, ssh, helix, kitty, neovim, etc. |

**User Package Categories**:
- **Development**: aider-chat, gemini-cli, lazygit, lazydocker, gitui, podman-tui, zed-editor
- **Shell tools**: zoxide, fzf, fd, ripgrep, bat, yazi, fastfetch
- **Terminal**: micro, mc, warp-terminal, tmux
- **Applications**: keepassxc
- **Media**: yt-dlp, gallery-dl, instaloader, spotdl

### Desktop Environments (`/desktop/`)

| Environment | Module | Use Case |
|------------|---------|----------|
| **KDE Plasma** | `kde.nix` | Primary desktop for desk workstation |
| **GNOME** | `gnome.nix` | Surface Pro tablet experience |
| **XFCE** | `xfce.nix` | Lightweight alternative |
| **Niri** | `niri.nix` | Experimental Wayland compositor |

### Service Modules (`/services/`)

**Core Services**:
| Service | Module | Purpose |
|---------|---------|---------|
| **Podman** | `podman.nix` | Container backend (OCI containers) |
| **SSH** | `ssh.nix` | Remote access, key-based authentication |
| **Tailscale** | `tailscale.nix` | VPN connectivity, mesh networking |
| **Samba** | `samba-client.nix` / `samba-server.nix` | File sharing |
| **Ollama** | `ollama.nix` | Local AI model serving |
| **Remote Desktop** | `remote-desktop.nix` | RDP/RustDesk access |

**Advanced Services**:
| Service | Module | Special Features |
|---------|---------|-----------------|
| **Forgejo** | `forgejo.nix` | Git server with container registry |
| **BorgBackup** | `borgbackup-repo.nix` | Backup repository server |
| **PMC-25** | `pmc-25.nix` | Advanced container orchestration |
| **Syncthing** | `syncthing.nix` | File synchronization |

### Container Services (`/services/containers/`)

**Container Backend**: `virtualisation.oci-containers.backend = "podman"`

| Container | Module | Purpose | Ports | Volumes |
|-----------|---------|---------|-------|---------|
| **Karakeep** | `karakeep.nix` | Knowledge management | 8080 | data:/app/data |
| **Homepage** | `homepage.nix` | Dashboard | 3000 | config:/app/config |
| **Audiobookshelf** | `audiobookshelf.nix` | Audiobook/Podcast server | 13378 | audiobooks:/audiobooks, metadata:/metadata, config:/config |
| **Claude Code Proxy** | `claude-code-proxy.nix` | AI assistant proxy | 8080 | N/A |
| **OpenHands** | `openhands.nix` | AI coding assistant | 3000 | workspace:/workspace |
| **Open WebUI** | `open-webui.nix` | Web-based AI interface | 8080 | data:/app/backend/data |

**Container Template**: `template.nix` - starting point for new services

### Gaming (`/gaming/`)

| Module | Purpose | Games/Tools |
|--------|---------|---------------|
| `gaming.nix` | Gaming optimizations | Steam, game mode, performance tweaks |
| `games/ksp.nix` | Kerbal Space Program | Space simulation game specific config |

### Hardware Support (`/hardware/`)

| Module | Purpose | Target Hardware |
|--------|---------|-----------------|
| `amd.nix` | AMD GPU support | Vulkan drivers, ROCm, AMD-specific optimizations |

### Specialized Configurations (`/portable/`)

| Module | Purpose | Use Case |
|--------|---------|----------|
| `sensors.nix` | Hardware sensors | Temperature/fan monitoring |
| `gjs-osk.nix` | On-screen keyboard | Tablet/touchscreen devices |
| `power-management.nix` | Power optimization | Battery life, suspend/resume |

## 🚀 Deployment & Management

### System Operations

```bash
# Build and switch configuration
sudo nixos-rebuild switch --flake .#<hostname>

# Test configuration without switching
sudo nixos-rebuild test --flake .#<hostname>

# Update flake inputs
nix flake update

# Check flake validity
nix flake check
```

### Colmena Deployment (from mini)

**Deployment Controller**: mini host manages all other systems

```bash
# Deploy to all hosts
colmena apply

# Deploy to specific hosts
colmena apply --on desk,rica

# Build without deploying
colmena build

# Deploy locally
colmena apply-local --sudo

# Check deployment plan
colmena eval
```

**Deployment Configuration**:
- **SSH Access**: User `ham` with sudo for activation
- **Network**: Tailscale hostnames (desk, rica, mini, surface)
- **Remote Builder**: Supported for cross-compilation
- **Shared Modules**: Same modules as nixosConfigurations

### Fast Building with nix-fast-build

**Performance Optimization**: Parallel evaluation + streaming builds

```bash
# Build current system checks (compact output)
nfb

# Build all systems (x86_64 + aarch64)
nfb-all

# Optimized fast build (skip cached, minimal output)
nfb-fast

# Remote build on SSH host
nfb-remote ham@desk

# Build with Cachix upload
nix-fast-build --cachix-cache <cache-name> --flake .#checks.$(nix eval --raw --impure --expr builtins.currentSystem)
```

**Key Features**:
- **Parallel Evaluation**: Uses nix-eval-jobs for concurrent attribute evaluation
- **Streaming Builds**: Starts builds immediately as attributes finish evaluating
- **Remote Building**: Uploads flake, builds remotely, downloads results
- **Binary Cache Support**: Upload to Cachix or Attic
- **CI Integration**: Machine-readable output for automation systems

### Package Search with nix-search-tv

```bash
# Interactive fuzzy search with preview
nix-search-tv print | fzf --preview 'nix-search-tv preview {}' --scheme history

# Recommended alias
alias ns="nix-search-tv print | fzf --preview 'nix-search-tv preview {}' --scheme history"

# Direct search
nix-search-tv print | grep firefox
```

**Search Registries**:
- **Nixpkgs**: Official package collection
- **Home Manager**: User-level packages and options
- **NixOS Options**: System configuration options
- **Darwin**: macOS/nix-darwin specific packages
- **NUR**: User repository for community packages

## 🔐 Security & Secrets

### SOPS Configuration

**Encryption**: AGE with 4 recipients for redundancy

**Secrets Include**:
- API keys (OpenRouter, Gemini)
- SMB credentials
- Network IP configurations
- SSH private keys
- Service authentication tokens

**Runtime Access**: Secrets decrypted at system activation, available at `/run/secrets/` with 0400 permissions and root ownership.

**Security Best Practices**:
- **Critical Issue**: SSH keys hardcoded in `hosts/desk/default.nix:32-33` - should migrate to SOPS secrets
- **Recommendation**: All sensitive data should be in SOPS secrets, not configuration files

## 🧠 AI Assistant Integration

### Claude Code with MCP Servers

**Specialized Agents**:
- **general-purpose**: Multi-step research and complex task execution
- **statusline-setup**: Claude Code status line configuration
- **nixos-expert**: NixOS system administration and troubleshooting
- **gemini-consultant**: Code review, second opinions, high token count analysis

**MCP Server Integration**:
- **nixos**: Real-time NixOS package and option search
- **serena**: Intelligent codebase navigation and symbolic editing
- **context7**: Framework-specific documentation and patterns

### Gemini CLI Integration

**Usage**: `gemini -p "prompt"` for code review and alternative perspectives

**Use Cases**:
- Configuration change validation
- Code best practices review
- Complex system modifications
- Security-sensitive configurations
- Implementation approach comparison

**Recommended Workflow**: Always use Gemini CLI for code review as a second opinion, especially for configuration changes and new module implementations.

## 📚 Documentation & Knowledge Base

### Existing Documentation

**Core Documentation**:
- `README.md`: Basic project overview and usage
- `CLAUDE.md`: Claude Code specific instructions and repository guidance
- `secrets.yaml`: Encrypted secrets (not documentation, but security critical)

**Specialized Documentation**:
- `SuperClaude_Framework/`: Comprehensive AI assistant framework (separate but integrated)
- `docs/HOME_MANAGER_MIGRATION.md`: Migration guide from GNU Stow to Home Manager
- `services/containers/readme.md`: Container service examples and patterns

**Device-Specific**:
- `hosts/asahi/firmware/README.md`: Apple Silicon firmware requirements
- `dotfiles/hypr/README.md`: Hyprland configuration notes

### Knowledge Management

**Project Memory** (via Serena MCP):
- `code_style`: Coding standards and practices
- `project_overview`: High-level project understanding
- `done_checklist`: Completed tasks and validation
- `suggested_commands`: Useful commands and workflows

**Integration Patterns**:
- **Context7 MCP**: Framework-specific documentation access
- **NixOS MCP**: Real-time package and option discovery
- **Serena MCP**: Intelligent code navigation and editing

## 🔧 Development Workflow

### Configuration Management

**Module Addition**:
1. Create module file in appropriate directory (`system/`, `services/`, `desktop/`, etc.)
2. Import in relevant host `default.nix`
3. Test with `sudo nixos-rebuild test --flake .#hostname`
4. Use Gemini CLI for code review: `gemini -p "Review this module for best practices"`

**Home Manager Changes**:
1. Edit files in `home/programs/` or `home/default.nix`
2. Changes apply to all hosts (single user "ham")
3. Test with `sudo nixos-rebuild test --flake .#hostname`
4. Home Manager changes are user-level but require system rebuild

**New Host Addition**:
1. Copy template: `cp -r hosts/template hosts/new-hostname`
2. Generate hardware config: `nixos-generate-config --root /mnt`
3. Copy `hardware-configuration.nix` to new host directory
4. Edit `default.nix` to customize modules and hostname
5. Add to `flake.nix` under `nixosConfigs` attrset

### Container Service Addition

**Process**:
1. Copy template: `cp services/containers/template.nix services/containers/service-name.nix`
2. Edit service configuration (image, ports, volumes, environment)
3. Import in host's `default.nix`: `../../services/containers/service-name.nix`
4. Test with `podman logs service-name` or `lazydocker`

**Container Format**:
```nix
virtualisation.oci-containers.containers.<name> = {
  image = "docker/image:tag";
  autoStart = true;
  ports = ["host:container"];
  environment = { KEY = "value"; };
  volumes = ["host/path:container/path"];
};
```

## 🎛️ Advanced Features

### Remote Builder Configuration

**Purpose**: Cross-compilation and distributed builds
**Configuration**: `system/remote-builder.nix`
**Usage**: Enable for complex package builds or multi-architecture support

### BTRFS Integration

**Features**:
- **Snapshots**: System rollback capability
- **Subvolumes**: Organized filesystem layout
- **Optimization**: Performance tuning for SSD/NVMe storage
- **Configuration**: `system/btrfs.nix`

### Wake-on-LAN Support

**Enabled**: Desktop workstation for remote access
**Configuration**: Network module integration
**Use Case**: Remote management and deployment triggering

### Multi-Architecture Support

**x86_64-linux**: desk, rica, mini, surface
**aarch64-linux**: asahi (Apple Silicon M1/M2/M3)
**Special Handling**: Apple Silicon overlays, Asahi Linux integration

## 🐛 Known Issues & Technical Debt

### Critical Issues

1. **SSH Keys Hardcoded** (`hosts/desk/default.nix:32-33`)
   - **Risk**: Security vulnerability, credentials in version control
   - **Fix**: Migrate to SOPS secrets with proper runtime decryption
   - **Priority**: High

### Organizational Issues

1. **Commented Imports**: Several host configs contain commented module imports
   - **Files**: `hosts/desk/default.nix:12,13,14,20` and others
   - **Impact**: Configuration confusion, unclear module relationships
   - **Fix**: Clean up unused imports, document required modules

2. **Import Path Inconsistencies**: Different relative path styles across hosts
   - **Impact**: Maintenance complexity, potential breakage
   - **Fix**: Standardize module import paths across all host configurations

### Recommendations

**Immediate Actions**:
1. Migrate hardcoded SSH keys to SOPS secrets (critical security)
2. Clean up commented/unused imports in host configs
3. Standardize module import paths across hosts

**Future Improvements**:
1. Implement comprehensive testing suite with `nix flake check`
2. Add automated security scanning for secrets detection
3. Create documentation generation pipeline
4. Implement configuration drift detection

## 🔄 Migration History

### Home Manager Migration (Commit c77bf1f)

**Before**: GNU Stow-managed dotfiles in `~/.dotfiles`
**After**: Declarative Home Manager configs in `home/` directory

**Migration Benefits**:
- **Declarative**: All configuration in Nix expressions
- **Atomic**: Changes applied atomically via system rebuild
- **Versioned**: Configuration changes tracked in git
- **Consistent**: Same user configuration across all hosts

**Migrated Programs**: git, zsh, tmux, ssh, helix, kitty, neovim, nh
**New Programs**: aider-chat, lazygit, zoxide, fzf, ripgrep, bat, yazi, fastfetch, keepassxc, yt-dlp, gallery-dl, instaloader, spotdl, micro, mc, warp-terminal, zed-editor

### Serena MCP Integration (Commit c43cccd)

**Added**: Intelligent codebase navigation and editing capabilities

**New Capabilities**:
- **Symbolic Code Search**: Find classes, functions, methods by name path
- **Intelligent Code Editing**: Replace symbol bodies, insert before/after symbols
- **Project Management**: File operations, memory management, task tracking
- **Minimal Reading**: Symbol-level analysis before full file reads

**Integration**: `.mcp.json` configuration in repository root

## 📊 System Matrix Summary

| Component | Implementation | Status | Notes |
|-----------|----------------|---------|-------|
| **Package Management** | Nix Flakes | ✅ Active | Multi-architecture support |
| **Configuration** | Declarative Nix | ✅ Active | Modular design pattern |
| **Secrets** | SOPS + AGE | ✅ Active | 4 redundant recipients |
| **User Management** | Home Manager | ✅ Active | Migrated from Stow |
| **Container Backend** | Podman | ✅ Active | OCI containers |
| **Desktop Environments** | KDE/GNOME/XFCE/Niri | ✅ Active | Per-host selection |
| **Deployment** | Colmena | ✅ Active | Mini as controller |
| **AI Integration** | Claude Code + Gemini | ✅ Active | MCP server ecosystem |
| **Build Optimization** | nix-fast-build | ✅ Active | Parallel evaluation |
| **Package Search** | nix-search-tv | ✅ Active | Multi-registry search |
| **Documentation** | Markdown + MCP | 🔄 In Progress | This index generation |

## 🔗 External Dependencies & Integration

### Flake Inputs

| Input | Purpose | Version | Usage |
|--------|---------|---------|-------|
| `nixpkgs` | Main package collection | unstable | System packages |
| `nixpkgs-stable` | Stable packages | 25.05 | Production stability |
| `nixos-hardware` | Hardware support | master | Device drivers |
| `nixos-apple-silicon` | Apple Silicon support | master | M1/M2/M3 support |
| `sops-nix` | Secrets management | master | AGE encryption |
| `nix-ai-tools` | AI tools integration | master | Development tools |
| `disko` | Disk management | master | BTRFS configuration |
| `home-manager` | User configuration | master | User environment |
| `niri` | Wayland compositor | master | Experimental desktop |
| `nix-fast-build` | Build optimization | master | Performance |
| `nix-on-droid` | Android support | release-24.05 | Mobile deployment |

### External Services

| Service | Integration | Purpose | Configuration |
|---------|-------------|---------|-------------|
| **OpenRouter** | API key in SOPS | AI model access | `claude-code-router.nix` |
| **Gemini** | CLI integration | Code review | `gemini-cli` package |
| **Tailscale** | VPN mesh | Network connectivity | `services/tailscale.nix` |
| **Cachix** | Binary cache | Build acceleration | Optional upload target |
| **GitHub** | Git hosting | Version control | Forgejo self-hosting available |

---

*This project index was generated on 2025-11-29 using the /sc:index command with comprehensive analysis of the NixOS configuration repository structure, dependencies, and documentation.*
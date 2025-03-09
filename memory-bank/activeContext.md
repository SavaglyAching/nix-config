# NixOS Configuration Active Context

## Current Focus

The current focus of this project is to expand the NixOS configuration repository by adding support for a Microsoft Surface Pro 7 and implementing remote building capabilities, as well as resolving WiFi connectivity issues when upgrading to the unstable branch. This involves:

1. **Adding a New Host**
   - Creating configuration for a Microsoft Surface Pro 7
   - Integrating with nixos-hardware for Surface-specific optimizations
   - Setting up touchscreen and other hardware support
   - Resolving WiFi connectivity issues when upgrading to the unstable branch

2. **Implementing Remote Building**
   - Configuring nixos-surface to use nixos-desk as a remote builder
   - Setting up SSH keys for secure, passwordless authentication
   - Ensuring proper user permissions for distributed builds

3. **Continuing Repository Improvements**
   - Maintaining the modular directory structure
   - Ensuring consistent configuration across machines
   - Documenting new additions and processes
   - Creating detailed plans for resolving hardware-specific issues

## Recent Changes

The following changes have been made to the repository:

1. **Directory Structure**
   - Created a modular directory structure with hosts, modules, and home directories
   - Separated modules into system, desktop, and services categories

2. **Configuration Modularization**
   - Extracted configuration components into separate module files
   - Created host-specific configuration for nixos-desk
   - Set up home-manager configuration for user 'ham'

3. **Templates**
   - Created templates for new hosts and users
   - Updated README with instructions for using templates

4. **Documentation**
   - Created a comprehensive README
   - Set up memory bank for project context
   - Created a detailed plan for Surface Pro 7 configuration

5. **Remote Builder Implementation**
   - Created a dedicated remote-builder.nix module for distributed builds
   - Updated nixos-surface to use nixos-desk as a remote builder
   - Added Surface-specific SSH key to ham user's authorized keys
   - Created a test script (scripts/test-remote-builder.sh) for troubleshooting
   - Added comprehensive documentation in README-remote-builder.md

## Next Steps

The following steps are planned for the project:

1. **Implement Surface Pro 7 Configuration**
   - Create the nixos-surface host directory and configuration files
   - Update flake.nix to include nixos-hardware and the new host
   - Configure remote building capabilities

2. **Testing**
   - Test the Surface Pro 7 configuration
   - Verify that remote building works correctly
   - Ensure that all services are properly configured

3. **Additional Hosts**
   - Add configurations for other machines as needed
   - Test multi-machine setup

4. **Refinement**
   - Refine module structure based on usage
   - Optimize shared configurations
   - Add more specialized modules as needed

5. **Advanced Features**
   - Explore additional Nix Flakes features
   - Consider adding deployment tools
   - Investigate secrets management

## Active Decisions

The following decisions are currently being considered:

1. **Module Granularity**
   - How fine-grained should modules be?
   - Should related services be grouped or separated?

2. **User Management**
   - How to handle multiple users with different requirements?
   - What should be managed by Home Manager vs. system configuration?

3. **Update Strategy**
   - How to handle updates to nixpkgs and other inputs?
   - What testing should be done before applying updates?

4. **Backup and Recovery**
   - How to handle system backups?
   - What recovery procedures should be documented?

5. **Hardware-Specific Configurations**
   - How to best integrate hardware-specific optimizations?
   - What kernel parameters are needed for specific devices?
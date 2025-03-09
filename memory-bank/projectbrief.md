# NixOS Configuration Project Brief

## Project Overview
This project is a NixOS configuration repository using the Nix Flakes system. It's designed to support multiple machines with shared modules, making it easy to maintain consistent configurations across different systems while allowing for machine-specific customizations.

## Core Requirements
1. Support multiple machines with different hardware configurations
2. Maintain shared configuration modules for consistency
3. Use Nix Flakes for reproducible builds
4. Integrate Home Manager for user-specific configurations
5. Provide easy ways to add new hosts and users

## Project Goals
- Create a modular, maintainable NixOS configuration
- Simplify the process of adding new machines
- Ensure consistent system configuration across different machines
- Separate machine-specific and shared configurations
- Document the structure and usage for future reference

## Key Components
1. Host-specific configurations
2. Shared system modules
3. Service modules
4. Desktop environment modules
5. Home Manager user configurations
6. Templates for new hosts and users

## Success Criteria
- Easy to add new machines
- Clear separation of concerns
- Well-documented structure
- Reproducible builds using flakes
- Minimal duplication of configuration
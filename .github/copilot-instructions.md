# Instructions for nvim configuration

You are a senior developer, helping me work on a super nice nvim configuration.

## Project configuration

- Project root: /
- Context file: /CONTEXT.md
- Project overview file: /.github/copilot-instructions.md

## Rules for the nvim

- Source repository: /nvim/lua
- Nix packages: /nix/packages.nix
- Nix plugins: /nix/plugins.nix
- Nix flake: /flake.nix

- Rules
  - Load nvim plugins with kokovim.get_plugin_by_repo method
  - If there is any new plugins, ensure to add them to the nix
    - Nix packages/plugins files
    - Flake if not directly exposed as a nix package
    - Do not run nix build or nix flake update. Let me handle that.

## Pairing rules

- One change at the time, verify before continuing
- When in doubt, ask rather than assume

## Token Efficiency

- List directories before reading files
- Search before reading - locate, do not guess
- Use read_multiple_files for batched reads
- Ask which files matter rather than reading speculatively.

## Session end

- Update CONTEXT.md: What we did, what's next and new decisions
- Keep it lean - prune old sessions that are no longer relevant

# Neovim flake - kokovim

## Requirements

### For Nix builds

All dependencies are automatically included in the Nix flake.

### For pure nvim/lua setup (non-Nix)

- **tree-sitter-cli** (version 0.26.1 or later) - Required for nvim-treesitter
  main branch
  ```bash
  cargo install tree-sitter-cli
  ```
  Note: System package managers may have outdated versions. Using cargo ensures
  you get the latest version.

## Usage

### Run directly

```bash
nix run github:alexanderk/kokovim                    # with roslyn (default)
nix run github:alexanderk/kokovim#kokovim-no-roslyn  # without roslyn/rzls/netcoredbg
```

### NixOS module

```nix
# flake.nix
inputs.kokovim.url = "github:alexanderk/kokovim";

# configuration.nix
imports = [ inputs.kokovim.nixosModules.default ];

programs.kokovim.enable = true;
programs.kokovim.roslyn.enable = false; # opt-out to avoid building dotnet on Darwin
```

### Home Manager module

```nix
# flake.nix
inputs.kokovim.url = "github:alexanderk/kokovim";

# home.nix
imports = [ inputs.kokovim.homeManagerModules.default ];

programs.kokovim.enable = true;
programs.kokovim.roslyn.enable = false; # opt-out to avoid building dotnet on Darwin
```

### Overlay

```nix
# With roslyn (default)
nixpkgs.overlays = [ inputs.kokovim.overlays.default ];

# Without roslyn
nixpkgs.overlays = [ inputs.kokovim.overlays.withoutRoslyn ];
```

> **Note:** `overlays.withoutRoslyn` / `roslyn.enable = false` avoids building dotnet
> from source on Darwin (macOS), which takes a long time.

## Configuration

Neovim for nix [Context:
https://github.com/NixOS/nixpkgs/blob/f71ccdc1bc17dffc83a8c49d0aa9ae92644572ab/doc/languages-frameworks/neovim.section.md?plain=1#L3]

## LSP Commands

On Neovim 0.11+ nvim-lspconfig defers to the native `:lsp` command.

| Command | Description |
|---|---|
| `:checkhealth vim.lsp` | LSP status (replaces `:LspInfo`) |
| `:lsp enable roslyn` | Start roslyn (always specify server — `:lsp enable` alone picks `csharp_ls`) |
| `:lsp stop roslyn` | Stop roslyn |
| `:lsp restart roslyn` | Restart roslyn |

## Debug

Check some of the paths

```bash
nix run . -- --headless -c 'echo stdpath("config") | q'
nix run . -- --headless -c 'echo &runtimepath | q'
nix run . -- --headless -c 'echo &packpath | q'
nix run . -- --headless -c 'echo $XDG_CONFIG_HOME | q'
```

## Inspect neovim-unwrapped

```bash
nix repl
:lf .#nixpkgs
pkgs = inputs.nixpkgs.legacyPackages."x86_64-linux"
pkgs.neovim-unwrapped
```

LazyFile event = { "BufReadPre", "BufNewFile" },

DeferredUIEnter event = "VeryLazy"

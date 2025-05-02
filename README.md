# Ale-nvim a nixvim based flake

## Run flake during development

```bash
nix run
nix build
```

## Add flake

```nix
{
    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        kokovim.url = "github:alexanderkohkoinen/nixvim-flake";
    };

    outputs = { self, nixpkgs, kokovim, ... }: {

        # Add to your system packages or devShell
        # if you want to make it available system-wide
        packages = with nixpkgs; [
            kokovim.packages.${system}.default
        ];

        # Or, use in a devShell:
        devShells.default = nixpkgs.mkShell {
            nativeBuildInputs = [ kokovim.packages.${system}.default ];
        };
    };
}
```

### Use with overlay and reference as nvim
```nix
{
    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        kokovim.url = "github:alexanderkohkoinen/nixvim-flake";
    };

    outputs = { self, nixpkgs, kokovim, ... }: {
        nixpkgs.overlays = [
            (final: prev: { neovim = kokovim.packages.${prev.system}.default; })
        ];
    };
}
```

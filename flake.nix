{
  description = "Kokovim - neovim flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";

    # External plugins
    vim-varnish.url = "github:varnishcache-friends/vim-varnish";
    vim-varnish.flake = false;

    mini-nvim.url = "github:echasnovski/mini.nvim";
    mini-nvim.flake = false;
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      treefmt-nix,
      ...
    }@inputs:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        overlays = [ ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
        kokovim-build = import ./nix/neovim.nix { inherit inputs system; };
        kokovim = pkgs.writeShellApplication {
          name = "nvim";
          runtimeInputs = [ kokovim-build.package ];
          text = ''
            export XDG_CONFIG_HOME="${kokovim-build.configPath}"
            export NVIM_LOG_FILE="$HOME/.local/state/nvim.log"
            exec nvim "$@"
          '';
        };
      in
      {
        packages.default = kokovim;
        packages.${system}.kokovim = kokovim;

        apps.default = {
          type = "app";
          program = "${kokovim}/bin/nvim";
        };

        devShells.default = pkgs.mkShell {
          name = "Kokovim - neovim shell";
          buildInputs = [ kokovim ];
        };
      }
    );
}

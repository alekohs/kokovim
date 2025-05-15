{
  description = "Kokovim - neovim flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    pkgs-by-name-for-flake-parts.url = "github:drupol/pkgs-by-name-for-flake-parts";

    mini-nvim = {
      url = "github:echasnovski/mini.nvim";
      flake = false;
    };

    blink-cmp = {
      url = "github:saghen/blink.cmp";
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
      };
    };

    snacks-nvim = {
      url = "github:folke/snacks.nvim";
      flake = false;
    };
  };
  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      ...
    }@inputs:
    flake-utils.lib.eachDefaultSystem (
      system:
      let

        kokovim = final: prev: {
          kokovim =
            let
              pkgs = prev;
            in
            import ./flake/neovim.nix {
              inherit inputs pkgs system;
            };
        };

        overlays = [ kokovim ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
      in
      {
        imports = [./flake/pkgs-by-name.nix];

        packages.default = pkgs.kokovim;
        packages.kokovim = pkgs.kokovim;
        # packages.kokovim-pure = kokovim-pure;

        apps.default = {
          type = "app";
          program = "${pkgs.kokovim}/bin/nvim";
        };

        apps.kokovim = {
          type = "app";
          program = "${pkgs.kokovim}/bin/nvim";
        };

        devShells.default = pkgs.mkShell {
          name = "Kokovim - neovim shell";
          buildInputs = [ pkgs.kokovim ];
        };
      }
    );
}

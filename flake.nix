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
        kokovim = final: prev: {
          kokovim =
            let
              pkgs = prev;
            in
            import ./nix/neovim.nix {
              inherit inputs pkgs system;
            };
        };

        overlays = [ kokovim ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };

        # kokovim-build = import ./nix/neovim.nix {
        #   inherit inputs pkgs system;
        #   with-config = true;
        # };
        #
        # kokovim-build-configless = import ./nix/neovim.nix {
        #   inherit inputs system;
        #   with-config = false;
        # };

        # kokovim = kokovim-build.package;
        # kokovim-app = pkgs.writeShellApplication {
        #   name = "nvim";
        #   runtimeInputs = [ kokovim-build.package ];
        #   text = ''
        #     export NVIM_LOG_FILE="$HOME/.local/state/nvim.log"
        #     export XDG_CONFIG_HOME="${kokovim-build.configPath}"
        #     exec nvim "$@"
        #   '';
        # };
        #
        # kokovim-pure = kokovim-build-configless.package;
      in
      {
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
          # shellHook = ''
          #   echo ${kokovim-build.configPath}
          # '';
        };
      }
    );
}

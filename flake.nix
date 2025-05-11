{
  description = "Kokovim - neovim flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    # neovim-nightly-overlay = {
    #   url = "github:nix-community/neovim-nightly-overlay";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils
      # neovim-nightly-overlay,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        # overlays = [ neovim-nightly-overlay.overlays.default ];
        overlays = [ ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };

        config = ./config/nvim;

        kokovim = pkgs.wrapNeovim pkgs.neovim-unwrapped {
          configure = {
              plugins = with pkgs.vimPlugins; [
                vim-nix
                telescope-nvim
                plenary-nvim
            ];
            extraWrapperArgs = ''
              --set XDG_CONFIG_HOME ${config}
              '';
          };

        };
      in
      {
        packages.default = kokovim;

        apps.default = {
          type = "app";
          program = "${kokovim}/bin/nvim";
        };

        devShells.default = pkgs.mkShell {
          buildInputs = [ kokovim ];
        };
      }
    );
}

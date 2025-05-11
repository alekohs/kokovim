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
      flake-utils,
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

        nvim-config-path = ./config;

        kokovim = pkgs.wrapNeovim pkgs.neovim-unwrapped {
          configure = {
            plugins = with pkgs.vimPlugins; [
              vim-nix
              telescope-nvim
              plenary-nvim
              rose-pine
            ];

            # Extra arguments for the wrapper to set the XDG_CONFIG_HOME
            extraWrapperArgs = ''
              export XDG_CONFIG_HOME=${nvim-config-path}
              exec ${pkgs.neovim-unwrapped}/bin/nvim "$@"
            '';
          };

        };
      in
      {
        packages.default = kokovim;
        packages.x86_64-linux.kokovim = kokovim;

        apps.default = {
          type = "app";
          program = "${kokovim}/bin/nvim";
        };

        devShells.default = pkgs.mkShell {
          buildInputs = [ kokovim ];
          shellHook = ''
            export XDG_CONFIG_HOME=${nvim-config-path}
            echo "XDG_CONFIG_HOME is set to ${nvim-config-path}"  # Debugging: print out the config path
            ls -al $XDG_CONFIG_HOME
          '';
        };
      }
    );
}

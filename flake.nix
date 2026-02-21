{
  description = "Kokovim - neovim flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # TODO Update to lastest when a fix is in place
    # Pointed to rev before breaking roslyn
    nixpkgs-roslyn.url = "github:nixos/nixpkgs/a5425d5c2dcdcb0305e8c2658c03068763133c80";

    flake-utils.url = "github:numtide/flake-utils";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    gen-luarc.url = "github:mrcjkb/nix-gen-luarc-json";

    pkgs-by-name-for-flake-parts.url = "github:drupol/pkgs-by-name-for-flake-parts";

    mini-nvim = {
      url = "github:echasnovski/mini.nvim";
      flake = false;
    };

    monoglow = {
      url = "github:wnkz/monoglow.nvim";
      flake = false;
    };

    xcodebuild-nvim = {
      url = "github:wojciech-kulik/xcodebuild.nvim";
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

    colorful-menu-nvim = {
      url = "github:xzbdmw/colorful-menu.nvim";
      flake = false;
    };

    pymobiledevice3-flake = {
      url = "github:doronz88/pymobiledevice3";
      flake = false;
    };

    oil-lsp-diagnostics-nvim = {
      url = "github:JezerM/oil-lsp-diagnostics.nvim";
      flake = false;
    };

    roslyn-nvim = {
      url = "github:seblyng/roslyn.nvim";
      flake = false;
    };

    nvim-treesitter = {
      url = "github:nvim-treesitter/nvim-treesitter/main";
      flake = false;
    };

    nvim-treesitter-textobjects = {
      url = "github:nvim-treesitter/nvim-treesitter-textobjects/main";
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
    let
      appName = "kokovim";
      neovim-overlay = import ./nix/default.nix {
        inherit inputs;
        appName = appName;
      };
    in
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        overlays = [
          neovim-overlay
          inputs.gen-luarc.overlays.default
        ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
      in
      {
        packages = rec {
          default = pkgs.nvim-pkg;
          kokovim = pkgs.nvim-pkg;
          nvim = pkgs.nvim-default;
        };

        apps.default = {
          type = "app";
          program = "${pkgs.nvim-pkg}/bin/${appName}";
        };

        apps.kokovim = {
          type = "app";
          program = "${pkgs.nvim-pkg}/bin/${appName}";
        };

        apps.neovim = {
          type = "app";
          program = "${pkgs.neovim}/bin/nvim";
        };

        devShells = {
          default = pkgs.mkShell {
            name = "Kokovim - develop shell";
            buildInputs = [ pkgs.nvim-pkg ];
          };

          symlink = pkgs.mkShell {
            name = "Kokovim - develop shell with symlink";
            buildInputs = [ pkgs.nvim-dev ];
            shellHook = ''
              export NVIM_APPNAME="${appName}-dev"
              # symlink the .luarc.json generated in the overlay
              ln -fs ${pkgs.nvim-luarc-json} .luarc.json
              # allow quick iteration of lua configs
              ln -Tfns $PWD/nvim ~/.config/${appName}-dev
              alias nvim="${pkgs.nvim-dev}/bin/${appName}-dev"
            '';
          };

        };
      }
    )
    // {
      # You can add this overlay to your NixOS configuration
      overlays.default = neovim-overlay;
    };
}

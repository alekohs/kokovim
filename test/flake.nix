{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    utils.url = "github:numtide/flake-utils";
    kokovim.url = "path:../";
  };

  outputs =
    {
      self,
      kokovim,
      nixpkgs,
      utils,
    }:
    utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            (final: prev: {
              neovim = kokovim.packages.${prev.system}.default;
            })
          ];
        };

        defaultVersion = "9";

      in
      {
        defaultPackage =
          with pkgs;
          mkShell {
            name = "Dotnet${defaultVersion}";
            packages = [ ];
            buildInputs = [
              dotnetCorePackages."sdk_${defaultVersion}_0"
              csharpier
              neovim
            ];
            shellHook = hook;
          };
      }
    );
}

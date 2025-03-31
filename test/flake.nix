{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    utils.url = "github:numtide/flake-utils";
    kokovim.url = "github:alekohs/kokovim/dotnet8";
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
          config = {
            config = {
              allowUnfree = true; # For unfree packages like Google Chrome
              allowInsecurePredicate =
                pkg:
                builtins.elem (pkgs.lib.getName pkg) [
                  "dotnetCorePackages.sdk_5_0"
                  "dotnetCorePackages.sdk_6_0"
                  "dotnetCorePackages.sdk_7_0"
                ];
            };
          };
        };

        defaultVersion = "9";

        hook = ''
          export NIXPKGS_ALLOW_INSECURE=1
          if command -v dotnet ef > /dev/null; then
              dm=true
          else
              echo 'Installing EF core tools'
              dotnet tool install --global dotnet-ef
          fi

        '';
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

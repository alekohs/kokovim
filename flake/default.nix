{ inputs, pkgs, ... }:
{
  imports = [
    ./pkgs-by-name.nix
  ];

  perSystem =
    { config, system, ... }:
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

    in
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      packages.default = kokovim;
      packages.kokovim = kokovim;
      devShells.default = kokovim;
    };
}

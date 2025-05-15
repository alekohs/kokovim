{ inputs, pkgs, ... }:
{
  imports = [
    # ./neovim.nix
    ./pkgs-by-name.nix
  ];

  perSystem =
    { config, system, ... }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      packages.default = config.packages.kokovim;
      packages.kokovim = config.packages.kokovim;
      devShells.default = config.packages.kokovim;
    };
}

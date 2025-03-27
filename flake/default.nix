{ inputs, pkgs, ... }:
{
  imports = [
    ./nixvim.nix
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
      packages.nvim = config.packages.kokovim;
      devShells.default = config.packages.kokovim;
    };
}

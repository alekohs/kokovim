{
  inputs,
  system,
  with-config ? true,
  ...
}:
let
  pkgs = import inputs.nixpkgs { inherit system; };
  lib = pkgs.lib;
  name = "kokovim";

  # Optionals
  opts = {
    withSQLite = false; # I dont use any plugin that requires sqlite.lua atm
  };

  plugins = import ./plugins.nix { inherit inputs pkgs opts; };
  packages = import ./packages.nix { inherit pkgs; };

  # Extra packages in $PATH
  # Grouped in buildEnv to avoid multiple $PATH entries
  externalPackages = pkgs.buildEnv {
    name = "${name}-external-pkgs";
    paths = packages.packages;
  };

  # Neovim config directory (init.lua, lua/, ...)
  nvimConfig = pkgs.stdenv.mkDerivation {
    name = "${name}-config";
    src = ../nvim;
    installPhase = ''
      mkdir -p "$out/nvim"
      shopt -s dotglob # Include hidden files in glob patterns
      cp -r * "$out/nvim/"
    '';
  };

  # Additional arguments for the Neovim wrapper
  extraMakeWrapperArgs = builtins.concatStringsSep " " (
    [
      ''--prefix PATH : "${lib.makeBinPath [ externalPackages ]}"''
      ''--set NVIM_NIX "1"''
      ''--set NVIM_APPNAME "${name}"''
    ]
    ++ (lib.optionals with-config [ ''--set XDG_CONFIG_HOME "${nvimConfig.outPath}"'' ])
    ++ (lib.optionals opts.withSQLite [
      ''--set LIBSQLITE "${pkgs.sqlite.out}/lib/libsqlite3.${
        if pkgs.stdenv.isDarwin then "dylib" else "so"
      }"''
      { }
    ])
  );

in
{
  package = pkgs.wrapNeovim pkgs.neovim-unwrapped {
    configure = {
      extraPackages = packages.packages;
      packages."${name}-plugins".start = plugins;
      wrapperArgs = extraMakeWrapperArgs;
    };
  };

  configPath = nvimConfig.outPath;
}

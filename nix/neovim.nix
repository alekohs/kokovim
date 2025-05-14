{
  inputs,
  pkgs,
  with-config ? true,
  ...
}:
let
  # pkgs = import inputs.nixpkgs { inherit system; };
  lib = pkgs.lib;
  name = "kokovim";

  # Optionals
  opts = {
    withSQLite = false; # I dont use any plugin that requires sqlite.lua atm
  };

  # customRC = import ./config { inherit pkgs; };
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
            # mkdir -p "$out/nvim"
            # shopt -s dotglob # Include hidden files in glob patterns
            # cp -r * "$out/nvim/"

      mkdir -p "$out/"
      shopt -s dotglob # Include hidden files in glob patterns
      cp -r * "$out/"

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

  kokovim = pkgs.wrapNeovim pkgs.neovim-unwrapped {
    configure = {
      inherit nvimConfig;
      # extraPackages = packages.packages;
      packages.kokovim.start = plugins;
      wrapperArgs = extraMakeWrapperArgs;
    };
  } // builtins.trace "Path to config: ${nvimConfig.outPath}" {};

in
pkgs.writeShellApplication {
  name = "nvim";
  runtimeInputs = [ externalPackages ];
  text = ''
    ${kokovim}/bin/nvim "$@"
  '';
}

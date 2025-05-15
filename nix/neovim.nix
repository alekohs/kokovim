{
  inputs,
  pkgs,
  with-config ? true,
  with-isolation ? true,
  ...
}:
let
  # pkgs = import inputs.nixpkgs { inherit system; };
  lib = pkgs.lib;
  appName = "kokovim";

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
    name = "${appName}-external-pkgs";
    paths = packages.packages;
  };

  neovimConfig = pkgs.neovimUtils.makeNeovimConfig {
    name = appName;
    withPython3 = false;
    withNodeJs = false;
    withRuby = false;
    extraPython3Packages = packages.extraPython3Packages;
    extraLuaPackages = packages.extraLuaPackages;

    plugins = plugins;
    customRC = "";
    wrapRc = false;
  };

  # Neovim config directory (init.lua, lua/, ...)
  kokovimHome = pkgs.stdenv.mkDerivation {
    name = "${appName}-config";
    src = ../nvim;
    installPhase = ''
      mkdir -p "$out/${appName}"
      shopt -s dotglob # Include hidden files in glob patterns
      cp -r * "$out/${appName}/"
    '';
  };

  # Additional arguments for the Neovim wrapper
  extraMakeWrapperArgs = builtins.concatStringsSep " " (
    [
      ''--prefix PATH : "${lib.makeBinPath [ externalPackages ]}"''
      ''--set NVIM_NIX "1"''
      ''--set NVIM_APPNAME "${appName}"''
    ]
    ++ (lib.optionals with-config [ ''--set XDG_CONFIG_HOME "${kokovimHome.outPath}"'' ])
    ++ (lib.optionals opts.withSQLite [
      ''--set LIBSQLITE "${pkgs.sqlite.out}/lib/libsqlite3.${
        if pkgs.stdenv.isDarwin then "dylib" else "so"
      }"''
      { }
    ])
  );

  kokovim = pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped (
    neovimConfig
    // {
      wrapperArgs = lib.escapeShellArgs neovimConfig.wrapperArgs + " " + extraMakeWrapperArgs;
    }
  );
in
pkgs.writeShellApplication {
  name = "nvim";
  runtimeInputs = [ externalPackages ];
  text = ''
    ${kokovim}/bin/nvim "$@"
  '';
}

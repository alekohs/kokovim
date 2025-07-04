# This overlay, when applied to nixpkgs, adds the final neovim derivation to nixpkgs.
{ inputs, appName, ... }:
final: prev:
with final.pkgs.lib;
let
  opts = {
    withSQLite = false; # I dont use any plugin that requires sqlite.lua atm
  };

  pkgs = final;
  pkgs-locked = inputs.nixpkgs.legacyPackages.${pkgs.system};
  pkgs-unstable = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system};

  # This is the helper function that builds the Neovim derivation.
  mkNeovim = pkgs.callPackage ../lib/mkNeovim.nix {
    inherit (pkgs-locked) wrapNeovimUnstable neovimUtils;
  };

  plugins = import ./plugins.nix { inherit inputs pkgs opts; };
  packages = import ./packages.nix { inherit inputs pkgs pkgs-unstable; };
in
{
  # This is the neovim derivation
  # returned by the overlay
  nvim-pkg = mkNeovim {
    plugins = plugins;
    extraPackages = packages.extraPackages;
    extraLuaPackages = packages.extraLuaPackages;
    extraPythonPackages = packages.extraPython3Packages;
    appName = appName;
    wrapRc = true;
  };

  # This is meant to be used within a devshell.
  # Instead of loading the lua Neovim configuration from
  # the Nix store, it is loaded from $XDG_CONFIG_HOME/nvim-dev
  nvim-dev = mkNeovim {
    plugins = plugins;
    extraPackages = packages.extraPackages;
    extraLuaPackages = packages.extraLuaPackages;
    extraPythonPackages = packages.extraPython3Packages;
    appName = "${appName}-dev";
    wrapRc = false;
    useNix = false;
  };

  # This can be symlinked in the devShell's shellHook
  nvim-luarc-json = final.mk-luarc-json {
    plugins = plugins;
  };

  # You can add as many derivations as you like.
  # Use `ignoreConfigRegexes` to filter out config
  # files you would not like to include.
  #
  # For example:
  #
  # nvim-pkg-no-telescope = mkNeovim {
  #   plugins = [];
  #   ignoreConfigRegexes = [
  #     "^plugin/telescope.lua"
  #     "^ftplugin/.*.lua"
  #   ];
  #   inherit extraPackages;
  # };
}

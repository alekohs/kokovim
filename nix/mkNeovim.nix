# Variant of https://github.com/nix-community/kickstart-nix.nvim/blob/main/nix/mkNeovim.nix
{
  pkgs,
  lib,
  stdenv,
  sqlite,
  git,
  neovim-unwrapped,
  # Set by the overlay to ensure we use a compatible version of `wrapNeovimUnstable`
  wrapNeovimUnstable,
  neovimUtils,
}:
with lib;
{
  appName ? null,
  plugins ? [ ],
  devPlugins ? [ ],
  extraPackages ? [ ],
  extraPythonPackages ? p: [ ],
  extraLuaPackages ? p: [ ],
  ignoreConfigRegexes ? [ ],
  wrapRc ? true,
  useNix ? true,
  useSSH ? true,
  withSqlite ? false,
  # Add a "vi" binary to the build output as an alias?
  viAlias ? appName == null || appName == "nvim",
  # Add a "vim" binary to the build output as an alias?
  vimAlias ? appName == null || appName == "nvim",
}:
let
  externalPackages = extraPackages;

  defaultPlugin = {
    plugin = null; # e.g. nvim-lspconfig
    config = null; # plugin config
    # If `optional` is set to `false`, the plugin is installed in the 'start' packpath
    # set to `true`, it is installed in the 'opt' packpath, and can be lazy loaded with
    # ':packadd! {plugin-name}
    optional = false;
    runtime = { };
  }; # Map all plugins to an attrset { plugin = <plugin>; config = <config>; optional = <tf>; ... }

  normalizedPlugins = map (x: defaultPlugin // (if x ? plugin then x else { plugin = x; })) plugins;

  # This uses the ignoreConfigRegexes list to filter
  # the nvim directory
  nvimRtpSrc =
    let
      src = ../nvim;
    in
    lib.cleanSourceWith {
      inherit src;
      name = "${appName}-rtp-src";
      filter =
        path: tyoe:
        let
          srcPrefix = toString src + "/";
          relPath = lib.removePrefix srcPrefix (toString path);
        in
        lib.all (regex: builtins.match regex relPath == null) ignoreConfigRegexes;
    };

  # Split runtimepath into 3 directories:
  # - lua, to be prepended to the rtp at the beginning of init.lua
  # - nvim, containing plugin, ftplugin, ... subdirectories
  # - after, to be sourced last in the startup initialization
  # See also: https://neovim.io/doc/user/starting.html
  nvimRtp = stdenv.mkDerivation {
    name = "${appName}-rtp";
    src = nvimRtpSrc;

    nativeBuildInputs = [ pkgs.rsync ];

    buildPhase = ''
      mkdir -p $out/nvim
      mkdir -p $out/lua

      rm init.lua
    '';

    installPhase = ''
      cp -r lua $out/lua
      rm -r lua

      # Copy rest of nvim/ subdirectories only if they exist
      if [ ! -z "$(ls -A)" ]; then
          cp -r -- * $out/nvim
      fi
    '';
  };

  # The final init.lua content that we pass to the Neovim wrapper.
  # It wraps the user init.lua, prepends the lua lib directory to the RTP
  # and prepends the nvim and after directory to the RTP
  # It also adds logic for bootstrapping dev plugins (for plugin developers)
  initLua =
    ''
      -- prepend lua and plugins directory
      vim.opt.rtp:prepend('${nvimRtp}/lua')
    ''
    # Wrap init.lua
    + (builtins.readFile ../nvim/init.lua)

    # Prepend nvim and after directories to the runtimepath
    # NOTE: This is done after init.lua,
    # because of a bug in Neovim that can cause filetype plugins
    # to be sourced prematurely, see https://github.com/neovim/neovim/issues/19008
    # We prepend to ensure that user ftplugins are sourced before builtin ftplugins.
    + ''
      vim.opt.rtp:prepend('${nvimRtp}/nvim')
    '';

  neovimConfig = neovimUtils.makeNeovimConfig {
    name = appName;
    withPython3 = false;
    withNodeJs = false;
    withRuby = false;
    extraPython3Packages = extraPythonPackages;
    extraLuaPackages = extraLuaPackages;

    plugins = normalizedPlugins;
    wrapRc = wrapRc;

    viAlias = viAlias;
    vimAlias = vimAlias;
  };

  extraMakeWrapperArgs = builtins.concatStringsSep " " (
    # Set the NVIM_APPNAME environment variable
    (optional (
      appName != "nvim" && appName != null && appName != ""
    ) ''--set NVIM_APPNAME "${appName}"'')
    # Add nix load status and set rp environment variable
    ++ (optional (useNix) ''--set NVIM_NIX "1"'')
    ++ (optional (useNix) ''--set NVIM_PLUGINS_RP "${nvimRtp}/plugins"'')
    ++ (optional (useSSH) ''--set NVIM_PLUGINS_SSH "1"'')
    # Add external packages to the PATH
    ++ (optional (externalPackages != [ ]) ''--prefix PATH : "${makeBinPath externalPackages}"'')
    # Set the LIBSQLITE_CLIB_PATH if sqlite is enabled
    ++ (optional withSqlite ''--set LIBSQLITE_CLIB_PATH "${sqlite.out}/lib/libsqlite3.so"'')
    # Set the LIBSQLITE environment variable if sqlite is enabled
    ++ (optional withSqlite ''--set LIBSQLITE "${sqlite.out}/lib/libsqlite3.so"'')
  );

  neovim-wrapped = wrapNeovimUnstable neovim-unwrapped (
    neovimConfig
    // {
      luaRcContent = initLua;
      wrapperArgs = escapeShellArgs neovimConfig.wrapperArgs + " " + extraMakeWrapperArgs;
      wrapRc = wrapRc;
    }
  );

  isCustomAppName = appName != null && appName != "nvim";
in
neovim-wrapped.overrideAttrs (oa: {
  buildPhase =
    oa.buildPhase
    # If a custom NVIM_APPNAME has been set, rename the `nvim` binary
    + lib.optionalString isCustomAppName ''
      mv $out/bin/nvim $out/bin/${lib.escapeShellArg appName}
    '';
  meta.mainProgram = if isCustomAppName then appName else oa.meta.mainProgram;
})

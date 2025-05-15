{ pkgs }:
{
  packages =
    with pkgs;
    [
      gcc # needed for nvim-treesitter

      # HTML, CSS, JSON
      vscode-langservers-extracted

      # LazyVim defaults
      stylua
      shfmt

      # Markdown extra
      markdownlint-cli2
      marksman

      # JSON and YAML extras
      nodePackages.yaml-language-server

      # Custom
      editorconfig-checker
      shellcheck
    ]
    ++ pkgs.lib.optionals pkgs.stdenv.isLinux [
      pkgs.fswatch # https://github.com/neovim/neovim/pull/27347
    ];

  # Extra lua packages to install, where package is 'xxx' in lua51Packages.xxx
  extraLuaPackages =
    ps: with ps; [
      jsregexp # required by luasnip
    ];

  # Extra python packages
  extraPython3Packages = _: [ ];
}

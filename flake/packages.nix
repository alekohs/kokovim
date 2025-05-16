{ pkgs }:
{
  packages =
    with pkgs;
    [
      gcc # needed for nvim-treesitter

      # Formatters
      gotools
      nixpkgs-fmt
      prettierd
      ruff
      stylua
      shfmt
      xmlformat
      yamlfmt

      # LSP
      gopls
      lua-language-server
      vscode-langservers-extracted
      marksman
      markdownlint-cli2
      yaml-language-server
      rust-analyzer
      nixd
      # ruff-lsp

      # LINT
      nodePackages.jsonlint
      yamllint
      deadnix
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
      luacheck
    ];

  # Extra python packages
  extraPython3Packages = _: [ ];
}

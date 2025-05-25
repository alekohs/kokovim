{ pkgs, pkgs-stable }:
{
  extraPackages =
    with pkgs;
    [
      gcc # needed for nvim-treesitter
      gh
      wordnet

      # Formatters
      codespell
      deno
      gotools
      nixpkgs-fmt
      nixfmt-rfc-style
      nixd
      prettierd
      ruff
      stylua
      shfmt
      xmlformat
      yamlfmt

      # LSP
      gopls
      fish-lsp
      lua-language-server
      vscode-langservers-extracted
      marksman
      markdownlint-cli2
      yaml-language-server
      taplo-cli
      rust-analyzer
      nixd
      tailwindcss-language-server
      nodePackages.tailwindcss
      nodePackages.typescript
      nodePackages.typescript-language-server
      sqls
      # dotnet lsp
      rzls
      roslyn-ls
      pkgs-stable.roslyn-ls # v4 of roslyn ls

      # LINT
      nodePackages.jsonlint
      nodePackages.markdownlint-cli
      biome
      stylelint
      yamllint
      deadnix
      editorconfig-checker
      shellcheck
      sqlfluff

    ]
    ++ pkgs.lib.optionals pkgs.stdenv.isLinux [
      pkgs.fswatch # https://github.com/neovim/neovim/pull/27347
    ]
    ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [

    ];


  # Extra lua packages to install, where package is 'xxx' in lua51Packages.xxx
  extraLuaPackages =
    ps: with ps; [
      jsregexp # required by luasnip
      luacheck
    ];

  # Extra python packages
  extraPython3Packages = pyth: with pyth; [
    pymobiledevice
  ];
}

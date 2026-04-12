{
  inputs,
  pkgs,
  pkgs-unstable,
  withRoslyn ? true,
  withUnstable ? false,
}:
let
  p = if withUnstable then pkgs-unstable else pkgs;
in
{

  extraPackages =
    with p;
    [
      fd
      gh
      wordnet
      openssl

      # Formatters
      codespell
      deno
      go
      gotools
      nixfmt
      prettierd
      prettier
      ruff
      shellharden
      stylua
      shfmt
      powershell
      xmlformat
      yamlfmt

      # LSP
      gopls
      fish-lsp
      lua-language-server
      vscode-langservers-extracted
      markdown-oxide
      markdownlint-cli2
      yaml-language-server
      taplo
      rust-analyzer
      nixd
      tailwindcss-language-server
      lemminx
      tailwindcss
      typescript
      typescript-language-server
      bash-language-server
      python313Packages.python-lsp-server
      sqls
      powershell-editor-services

      # LINT
      markdownlint-cli
      biome
      htmlhint
      stylelint
      yamllint
      deadnix
      editorconfig-checker
      shellcheck
      sqlfluff

      # For nvim-treesitter parser compilation
      tree-sitter

      # For snacks image to work
      imagemagick # Images
      # tectonic # PDF
      #mermaid-cli # Mermaid diagarams
    ]
    ++ p.lib.optionals withRoslyn [
      # dotnet LSP — requires building dotnet on Darwin, opt-in only
      p.rzls
      p.roslyn-ls

      # dotnet DAP
      p.netcoredbg
    ]
    # ++ p.lib.optionals p.stdenv.hostPlatform.isx86_64 [
    #       ]
    ++ p.lib.optionals p.stdenv.isLinux [
      pkgs.fswatch # https://github.com/neovim/neovim/pull/27347
    ]
    ++ p.lib.optionals p.stdenv.isDarwin [
      (p.ruby.withPackages (ps: [ ps.xcodeproj ]))
      sourcekit-lsp
      swiftlint
      swiftformat
      vscode-extensions.vadimcn.vscode-lldb
    ];

  # Extra lua packages to install, where package is 'xxx' in lua51Packages.xxx
  extraLuaPackages =
    ps: with ps; [
      jsregexp # required by luasnip
      luacheck
    ];

  # Extra python packages
  extraPython3Packages =
    pyth:
    with pyth;
    [
    ]
    ;
}

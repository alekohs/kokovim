{
  inputs,
  pkgs,
  pkgs-unstable,
  withRoslyn ? true,
  withUnstable ? false,
}:
let
  lib = import ../lib/mkFlakeBuild.nix { pkgs = pkgs; };
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
      nodePackages_latest.tailwindcss
      nodePackages_latest.typescript
      nodePackages_latest.typescript-language-server
      nodePackages_latest.bash-language-server
      python313Packages.python-lsp-server
      sqls

      # LINT
      #nodePackages_latest.jsonlint
      nodePackages_latest.markdownlint-cli
      biome
      htmlhint
      stylelint
      yamllint
      deadnix
      editorconfig-checker
      shellcheck
      sqlfluff

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

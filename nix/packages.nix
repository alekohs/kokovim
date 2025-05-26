{
  inputs,
  pkgs,
  pkgs-stable,
}:
let
  lib = import ../lib/mkFlakeBuild.nix { pkgs = pkgs; };
  python-packages = [
    {
      src = inputs.pymobiledevice3;
      pname = "pymobiledevice3";
    }
  ];

  flakePythons = map (p: lib.mkPythonPackage p) python-packages;

in
{

  extraPackages =
    with pkgs;
    [
      gcc # needed for nvim-treesitter
      gh
      wordnet
      vscode-extensions.vadimcn.vscode-lldb

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
      sourcekit-lsp

      # LINT
      nodePackages.jsonlint
      nodePackages.markdownlint-cli
      biome
      htmlhint
      stylelint
      yamllint
      deadnix
      editorconfig-checker
      shellcheck
      sqlfluff

      # DAP
      netcoredbg
    ]
    ++ pkgs.lib.optionals pkgs.stdenv.isLinux [
      pkgs.fswatch # https://github.com/neovim/neovim/pull/27347
    ]
    ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [
      ruby
      swiftlint
      swiftformat
    ];

  # Extra lua packages to install, where package is 'xxx' in lua51Packages.xxx
  extraLuaPackages =
    ps: with ps; [
      jsregexp # required by luasnip
      luacheck
    ];

  # Extra python packages
  extraPython3Packages = pyth: with pyth; [ ] ++ flakePythons;
}

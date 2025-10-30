{
  inputs,
  pkgs,
  pkgs-unstable,
}:
let
  lib = import ../lib/mkFlakeBuild.nix { pkgs = pkgs; };
  python-packages = [
    {
      src = inputs.pymobiledevice3-flake;
      pname = "pymobiledevice3";
      # format = "pyproject";
      pyproject = true;
      propagatedBuildInputs = with pkgs.python3Packages; [
        cryptography
        construct
        zeroconf
        libusb1
        packaging
      ];

      nativeBuildInputs = [ pkgs.pkg-config ];
    }
  ];

  flakePythons = map (p: lib.mkPythonPackage p) python-packages;
in
{

  extraPackages =
    with pkgs;
    [
      fd
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
      nodePackages.bash-language-server
      python313Packages.python-lsp-server
      sqls
      # dotnet lsp
      rzls
      roslyn-ls
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

      # For snacks image to work
      imagemagick # Images
      # tectonic # PDF
      mermaid-cli # Mermaid diagarams
    ]
    ++ pkgs.lib.optionals pkgs.stdenv.isLinux [
      pkgs.fswatch # https://github.com/neovim/neovim/pull/27347
    ]
    ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [
      (pkgs.ruby.withPackages (ps: [ ps.xcodeproj ]))
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
    ++ flakePythons;
}

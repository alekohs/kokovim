{
  inputs,
  pkgs,
  opts,
}:
let
  # Function to create a vim plugin from a flake input
  # NOTE: this is for luaPackages: https://github.com/NixOS/nixpkgs/blob/36dcdaf8f6b0e0860721ecd4aada50c0cccc3cfd/pkgs/applications/editors/neovim/build-neovim-plugin.nix#L11-L12
  # pkgs.neovimUtils.buildNeovimPlugin

  lib = import ../lib/mkFlakeBuild.nix { pkgs = pkgs; };
  nvim-treesitter-grammars = pkgs.symlinkJoin {
    name = "nvim-treesitter-grammars";
    paths = pkgs.vimPlugins.nvim-treesitter.withAllGrammars.dependencies;
  };

  markview-pkg = pkgs.vimPlugins.markview-nvim.overrideAttrs {
    version = "2025-01-30";
    src = pkgs.fetchFromGitHub {
      owner = "OXY2DEV";
      repo = "markview.nvim";
      rev = "f933b4597738fec4014d25f11511bcbe2d1e1a32";
      hash = "sha256-V3imWAzPtlrC89CYigDvnye12CctM7RJioigc57Rn/8=";
      fetchSubmodules = true;
    };
    doCheck = false;
  };

  plugins-spec = [
    {
      src = inputs.xcodebuild-nvim;
      pname = "xcodebuild.nvim";
      nvimSkipModule = [
        "xcodebuild.ui.pickers"
        "xcodebuild.actions"
        "xcodebuild.project.manager"
        "xcodebuild.project.assets"
        "xcodebuild.integrations.xcode-build-server"
        "xcodebuild.integrations.dap"
        "xcodebuild.code_coverage.report"
        "xcodebuild.dap"
      ];
    }
    {
      src = inputs.mini-nvim;
      pname = "mini-nvim";
      nvimSkipModule = [ ];
    }
  ];

  flakePlugins = map (p: lib.mkVimPlugin p) plugins-spec;

in
with pkgs.vimPlugins;
[
  # Package manager
  lazy-nvim

  # Dependencies
  plenary-nvim

  # AI
  codecompanion-nvim
  copilot-lua
  CopilotChat-nvim

  # code
  nvim-ts-autotag
  nvim-ts-context-commentstring
  neogen
  conform-nvim
  trouble-nvim

  # Editor
  fzf-lua
  oil-nvim
  neo-tree-nvim
  nui-nvim
  which-key-nvim
  bufferline-nvim
  lualine-nvim
  lazygit-nvim
  grug-far-nvim
  flash-nvim
  harpoon2
  noice-nvim
  nui-nvim
  gitsigns-nvim
  render-markdown-nvim
  markview-pkg
  yanky-nvim
  vim-wakatime
  todo-comments-nvim
  snacks-nvim

  # UI
  nvim-navic
  nvim-navbuddy
  dashboard-nvim
  nvim-notify
  fidget-nvim
  hardtime-nvim

  # Completion
  blink-cmp
  blink-cmp-dictionary
  blink-cmp-git
  blink-cmp-spell
  blink-cmp-copilot
  blink-compat
  blink-emoji-nvim
  blink-ripgrep-nvim
  blink-nerdfont-nvim
  colorful-menu-nvim

  # Treesitter
  nvim-treesitter
  nvim-treesitter-grammars
  nvim-treesitter-textobjects
  nvim-treesitter-context
  nvim-treesitter-refactor

  # Linting
  nvim-lint

  # LSP
  nvim-lspconfig
  roslyn-nvim
  rzls-nvim
  dotnet-nvim
  easy-dotnet-nvim

  # Colorschemes
  rose-pine

  # Other
  vim-nix

  # Plugins outside of nixpkgs

]
++ flakePlugins
++ (pkgs.lib.optionals opts.withSQLite [ sqlite-lua ])

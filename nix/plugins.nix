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
        "xcodebuild.integrations.fzf-lua"
        "xcodebuild.integrations.telescope-nvim"
        "xcodebuild.integrations.snacks-picker"
        "xcodebuild.code_coverage.report"
        "xcodebuild.dap"
      ];
    }
    {
      src = inputs.mini-nvim;
      pname = "mini-nvim";
      nvimSkipModule = [ ];
    }
    {
      src = inputs.monoglow;
      pname = "monoglow.nvim";
      nvimSkipModule = [ ];
    }
    {
      src = inputs.colorful-menu-nvim;
      pname = "colorful-menu-nvim";
      nvimSkipModule = [
        "repro_blink"
        "repro_cmp"
      ];
    }
    {
      src = inputs.otree-nvim;
      pname = "otree-nvim";
      nvimSkipModule = [
        "Otree.oil"
      ];
    }
    {
      src = inputs.oil-lsp-diagnostics-nvim;
      pname = "oil-lsp-diagnostics-nvim";
      nvimSkipModule = [ "oil-lsp-diagnostics" ];
    }

    {
      src = inputs.roslyn-nvim;
      pname = "roslyn.nvim";
      nvimSkipModule = [ ];
    }

    {
      src = inputs.nvim-treesitter;
      pname = "nvim-treesitter";
      nvimSkipModule = [ "nvim-treesitter._meta.parsers" ];
    }

    {
      src = inputs.nvim-treesitter-textobjects;
      pname = "nvim-treesitter-textobjects";
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

  # dap
  nvim-dap
  nvim-dap-ui
  nvim-nio
  nvim-dap-virtual-text
  nvim-dap-go
  nvim-dap-python

  # Editor
  telescope-nvim
  fzf-lua
  oil-nvim
  oil-git-status-nvim
  fyler-nvim
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
  peek-nvim
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
  tiny-inline-diagnostic-nvim
  transparent-nvim

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
  # nvim-treesitter is built from main via flakePlugins
  # nvim-treesitter-textobjects is built from main via flakePlugins
  nvim-treesitter-grammars
  nvim-treesitter-context

  # Linting
  nvim-lint

  # LSP
  nvim-lspconfig
  dotnet-nvim

  # Colorschemes
  rose-pine
  catppuccin-nvim
  nord-nvim
  zenbones-nvim
  lush-nvim

  # Other
  vim-nix

  # Plugins outside of nixpkgs

]
++ flakePlugins
++ (pkgs.lib.optionals opts.withSQLite [ sqlite-lua ])

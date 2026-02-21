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
    postBuild = ''
      # Only keep parser .so files — queries must come from the
      # nvim-treesitter plugin (flake input) to avoid version mismatches
      rm -rf $out/queries
    '';
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

  # code
  nvim-ts-autotag
  nvim-ts-context-commentstring
  neogen
  conform-nvim

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
  neo-tree-nvim
  nui-nvim
  which-key-nvim
  lualine-nvim
  grug-far-nvim
  flash-nvim
  harpoon2
  noice-nvim
  gitsigns-nvim
  render-markdown-nvim
  peek-nvim
  yanky-nvim
  vim-wakatime
  todo-comments-nvim
  snacks-nvim

  # UI
  nvim-navic
  nvim-navbuddy
  nvim-notify
  tiny-inline-diagnostic-nvim

  # Completion
  blink-cmp
  blink-cmp-git
  blink-cmp-copilot
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
  lsp-progress-nvim

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

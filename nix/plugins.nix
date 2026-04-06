{
  inputs,
  pkgs,
  opts,
  withRoslyn ? true,
}:
let
  # Function to create a vim plugin from a flake input
  # NOTE: this is for luaPackages: https://github.com/NixOS/nixpkgs/blob/36dcdaf8f6b0e0860721ecd4aada50c0cccc3cfd/pkgs/applications/editors/neovim/build-neovim-plugin.nix#L11-L12
  # pkgs.neovimUtils.buildNeovimPlugin

  lib = import ../lib/mkFlakeBuild.nix { pkgs = pkgs; };

  plugins-spec = [
    {
      src = inputs.mini-nvim;
      pname = "mini-nvim";
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
  fzf-lua
  oil-nvim
  oil-git-status-nvim
  which-key-nvim
  lualine-nvim
  grug-far-nvim
  flash-nvim
  harpoon2
  gitsigns-nvim
  diffview-nvim
  vim-wakatime
  todo-comments-nvim
  snacks-nvim

  # UI
  nvim-navic
  tiny-inline-diagnostic-nvim

  # Completion
  blink-cmp
  blink-cmp-copilot
  colorful-menu-nvim

  # Treesitter
  # nvim-treesitter-textobjects is built from main via flakePlugins
  nvim-treesitter-context

  # Linting
  nvim-lint

  # LSP
  nvim-lspconfig

  # Colorschemes
  rose-pine


  # Plugins outside of nixpkgs

]
++ flakePlugins
++ (pkgs.lib.optionals opts.withSQLite [ sqlite-lua ])
++ (pkgs.lib.optionals withRoslyn [
  (lib.mkVimPlugin {
    src = inputs.roslyn-nvim;
    pname = "roslyn.nvim";
    nvimSkipModule = [ ];
  })
])

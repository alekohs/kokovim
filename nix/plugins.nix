{
  inputs,
  pkgs,
  opts,
}:
let
  # Function to create a vim plugin from a flake input
  mkVimPlugin =
    { src, pname }:
    pkgs.vimUtils.buildVimPlugin {
      inherit pname src;
      version = src.lastModifiedDate;
    };

  # NOTE: this is for luaPackages: https://github.com/NixOS/nixpkgs/blob/36dcdaf8f6b0e0860721ecd4aada50c0cccc3cfd/pkgs/applications/editors/neovim/build-neovim-plugin.nix#L11-L12
  # pkgs.neovimUtils.buildNeovimPlugin

  nvim-treesitter-grammars = pkgs.symlinkJoin {
    name = "nvim-treesitter-grammars";
    paths = pkgs.vimPlugins.nvim-treesitter.withAllGrammars.dependencies;
  };
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
  yanky-nvim

  # UI
  nvim-navic
  nvim-navbuddy

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

  # Colorschemes
  rose-pine

  # Other
  vim-nix

  # Plugins outside of nixpkgs
  (mkVimPlugin {
    src = inputs.mini-nvim;
    pname = "mini-nvim";
  })
]
++ (pkgs.lib.optionals opts.withSQLite [ sqlite-lua ])

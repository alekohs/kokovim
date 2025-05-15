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

  # Merge nvim-treesitter parsers together to reduce vim.api.nvim_list_runtime_paths()
  nvim-treesitter-grammars = pkgs.symlinkJoin {
    name = "nvim-treesitter-grammars";
    paths = pkgs.vimPlugins.nvim-treesitter.withAllGrammars.dependencies;
  };
in
with pkgs.vimPlugins;
[
  # Package manager
  lazy-nvim

  # Editor
  telescope-nvim
  fzf-lua
  plenary-nvim
  oil-nvim
  neo-tree-nvim
  nui-nvim
  which-key-nvim
  bufferline-nvim
  lualine-nvim
  lazygit-nvim

  # Completion
  blink-cmp
  blink-cmp-dictionary
  blink-cmp-git
  blink-cmp-spell
  blink-cmp-copilot
  blink-compat
  blink-emoji-nvim
  blink-ripgrep-nvim

  # Treesitter
  nvim-treesitter
  nvim-treesitter-grammars

  # LSP
  nvim-lspconfig
  roslyn-nvim
  rzls-nvim
  dotnet-nvim

  # Colorschemes
  rose-pine

  # Other
  vim-nix

  colorful-menu-nvim

  # Plugins outside of nixpkgs
  (mkVimPlugin {
    src = inputs.mini-nvim;
    pname = "mini-nvim";
  })
]
++ (pkgs.lib.optionals opts.withSQLite [ sqlite-lua ])

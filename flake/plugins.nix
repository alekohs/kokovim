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

  # nvim-treesitter-grammars = pkgs.symlinkJoin {
  #   name = "nvim-treesitter-grammars";
  #   paths = pkgs.vimPlugins.nvim-treesitter.withAllGrammars.dependencies;
  # };

  # Merge nvim-treesitter parsers together to reduce vim.api.nvim_list_runtime_paths()
  nvim-treesitter-grammars = pkgs.symlinkJoin {
    name = "nvim-treesitter-grammars";
    paths =
      (pkgs.vimPlugins.nvim-treesitter.withPlugins (
        plugins: with plugins; [
          angular
          arduino
          bash
          c_sharp
          cmake
          cpp
          csv
          css
          scss
          dot
          dockerfile
          fish
          git_config
          gitignore
          go
          graphql
          html
          java
          javascript
          json
          kotlin
          lua
          make
          markdown
          nix
          nginx
          regex
          rust
          razor
          sql
          terraform
          typescript
          tsx
          tmux
          toml
          vim
          vimdoc
          xml
          yaml
          zig
        ]
      )).dependencies;
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

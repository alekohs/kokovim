{ pkgs, lib, ... }:
let
  events = [
    "DeferredUIEnter"
    "BufReadPost"
  ];
in
{
  plugins.treesitter = {
    enable = true;
    folding = true;

    lazyLoad = {
      settings.event = events;
      settings.cmd = [
        "TSUpdateSync"
        "TSUpdate"
        "TSInstall"
      ];
    };

    settings = {
      grammarPackages =
        with pkgs.vimPlugins.nvim-treesitter.builtGrammars;
        [
          bash
          c_sharp
          dockerfile
          # http
          fish
          go
          java
          javascript
          json
          lua
          make
          markdown
          nix
          nginx
          regex
          rust
          razor
          toml
          vim
          vimdoc
          xml
          yaml
          zig
        ]
        ++ lib.optionals pkgs.stdenv.isDarwin [
          swift
        ];

      highlight = {
        additional_vim_regex_highligtning = true;
        enable = true;
        disable = # Lua
          ''
            function(lang, bufnr)
              return vim.api.nvim_buf_line_count(bufnr) > 10000
            end
          '';
      };

      incremental_selection = {
        enable = true;
        keymaps = {
          init_selection = "gnn";
          node_incremental = "grn";
          scope_incremental = "grc";
          node_decremental = "grm";
        };
      };

      indent.enable = true;
    };

  };

  plugins.treesitter-context = {
    enable = true;
    lazyLoad.settings.event = events;

    settings = {
      min_window_height = 40;
      multiwindow = true;
      separator = "-";
      max_lines = 4;
    };
  };

  plugins.treesitter-refactor = {
    enable = true;
    highlightDefinitions = {
      enable = true;
      clearOnCursorMove = true;
    };
    smartRename = {
      enable = true;
    };
    navigation = {
      enable = true;
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>ut";
      action = "<CMD>TSContextToggle<CR>";
      options = {
        desc = "Treesitter Context toggle";
      };
    }
  ];

}

{
  plugins.trouble = {
    enable = true;
    lazyLoad.settings.cmd = [ "Trouble " ];
    settings = {
      modes = {
        lsp = {
          win = { position = "right"; };
        };
      };
   };
  };

  plugins.which-key.settings.spec = [
    {
      __unkeyed-1 = "<leader>x";
      mode = "n";
      icon = "";
      group = "Trouble";
    }
  ];

  keymaps = [
    {
      mode = "n";
      key = "<leader>xx";
      action = "<CMD>Trouble diagnostics toggle<CR>";
      options = {
        desc = "Diagnostics toggle";
      };
    }
    {
      mode = "n";
      key = "<leader>xX";
      action = "<CMD>Trouble diagnostics toggle filter.buf=0<CR>";
      options = {
        desc = "Buffer Diagnostics toggle";
      };
    }
    {
      mode = "n";
      key = "<leader>cs";
      action = "<CMD>Trouble symbols toggle<CR>";
      options = {
        desc = "Symbols toggle";
      };
    }
    {
      mode = "n";
      key = "<leader>xl";
      action = "<CMD>Trouble lsp toggle<CR>";
      options = {
        desc = "LSP Definitions / references / ... toggle";
      };
    }
    {
      mode = "n";
      key = "<leader>xL";
      action = "<CMD>Trouble loclist toggle<CR>";
      options = {
        desc = "Location List toggle";
      };
    }
    {
      mode = "n";
      key = "<leader>xQ";
      action = "<CMD>Trouble qflist toggle<CR>";
      options = {
        desc = "Quickfix List toggle";
      };
    }
    {
      mode = "n";
      key = "[q";
      action.__raw = # Lua
        ''
      function()
        if require("trouble").is_open() then
          require("trouble").prev({ skip_groups = true, jump = true })
        else
          local ok, err = pcall(vim.cmd.cprev)
          if not ok then
            vim.notify(err, vim.log.levels.ERROR)
          end
        end
      end
        '';
      options = {
        desc = "Previous trouble/quickfix item";
      };
    }
    {
      mode = "n";
      key = "]q";
      action.__raw = # Lua
        ''
      function()
        if require("trouble").is_open() then
          require("trouble").next({ skip_groups = true, jump = true })
        else
          local ok, err = pcall(vim.cmd.cprev)
          if not ok then
            vim.notify(err, vim.log.levels.ERROR)
          end
        end
      end
        '';
      options = {
        desc = "Next trouble/quickfix item";
      };
    }
  ];
}

let
  cond.__raw = ''
    function()
      local buf_size_limit = 1024 * 1024 -- 1MB size limit
      if vim.api.nvim_buf_get_offset(0, vim.api.nvim_buf_line_count(0)) > buf_size_limit then
        return false
      end

      return true
    end
  '';
in
{
  plugins.lualine = {
    enable = true;
    lazyLoad.settings.event = "DeferredUIEnter";

    settings = {
      options = {
        icons_enabled = true;
        globalstatus = true;
        theme = "rose-pine";

        disabled_filetypes = {
          __unkeyed-1 = "startify";
          __unkeyed-2 = "neo-tree";
          __unkeyed-3 = "copilot-chat";
          __unkeyed-4 = "ministarter";
          __unkeyed-5 = "Avante";
          __unkeyed-6 = "AvanteInput";
          __unkeyed-7 = "trouble";
          __unkeyed-8 = "dapui_scopes";
          __unkeyed-9 = "dapui_breakpoints";
          __unkeyed-10 = "dapui_stacks";
          __unkeyed-11 = "dapui_watches";
          __unkeyed-12 = "dapui_console";
          __unkeyed-13 = "dashboard";
          __unkeyed-14 = "snacks_dashboard";
          __unkeyed-15 = "snacks_layout_box";
          winbar = [
            "dap-repl"
            "neotest-summary"
          ];
        };
      };

      sections = {
        lualine_a = [ "mode" ];
        lualine_b = [
          {
            __unkeyed-1 = "branch";
            icon = "";
          }
          {
            __unkeyed-1 = "diff";
            symbols = {
              added = " ";
              modified = " ";
              removed = " ";
            };
          }
        ];
        lualine_c = [
          {
            __unkeyed-1 = "diagnostics";
            sources = [ "nvim_lsp" ];
            symbols = {
              error = " ";
              warn = " ";
              info = " ";
              hint = "󰝶 ";
            };
          }
          {
            __unkeyed-1 = "navic";
            inherit cond;
          }
        ];
        lualine_x = [
          "filetype"
          {
            __unkeyed-1 = "filename";
            path = 1;
          }
        ];

        lualine_y = [ "progress" ];
        lualine_z = [ "location" ];
      };
      winbar = {
        lualine_c = [
          {
            __unkeyed-1 = "navic";
            inherit cond;
          }
        ];
      };
    };

  };

  plugins.navic = {
    enable = true;
    lazyLoad.settings.event = "DeferredUIEnter";
    settings = {
      separator = "  ";
      highlight = true;
      depthLimit = 5;
      lsp = { autoAttach = true; };
      icons = {
        Array = "󱃵  ";
        Boolean = "  ";
        Class = "  ";
        Constant = "  ";
        Constructor = "  ";
        Enum = " ";
        EnumMember = " ";
        Event = " ";
        Field = "󰽏 ";
        File = " ";
        Function = "󰡱 ";
        Interface = " ";
        Key = "  ";
        Method = " ";
        Module = "󰕳 ";
        Namespace = " ";
        Null = "󰟢 ";
        Number = " ";
        Object = "  ";
        Operator = " ";
        Package = "󰏖 ";
        String = " ";
        Struct = " ";
        TypeParameter = " ";
        Variable = " ";
      };
    };
  };
}

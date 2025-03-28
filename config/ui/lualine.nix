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
        lualine_a = [
          {
            __unkeyed-1 = "mode";
          }
        ];
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
          }
        ];
        lualine_x = [
          {
            __unkeyed-1 = "filetype";
            icon_only = true;
            separator = "";
            padding = {
              left = 1;
              right = 0;
            };
          }
          {
            __unkeyed-1 = "filename";
            path = 1;
          }
          {
            __unkeyed-1.__raw = ''
              require("noice").api.statusline.mode.get,
              cond = require("noice").api.statusline.mode.has,
              color = { fg = "#eb6f92" },
            '';
          }
        ];
        lualine_y = [
          {
            __unkeyed-1 = "progress";
          }
        ];
        lualine_z = [
          {
            __unkeyed-1 = "location";
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
      lsp = {
        autoAttach = true;
      };
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

{
  plugins = {
    noice = {
      enable = true;
      settings = {
        # Hides the title above noice boxes
        cmdline = {
          format = {
            cmdline = {
              pattern = "^:";
              icon = "";
              lang = "vim";
              opts = {
                border = {
                  text = {
                    top = "Cmd";
                  };
                };
              };
            };
            search_down = {
              kind = "search";
              pattern = "^/";
              icon = " ";
              lang = "regex";
            };
            search_up = {
              kind = "search";
              pattern = "^%?";
              icon = " ";
              lang = "regex";
            };
            filter = {
              pattern = "^:%s*!";
              icon = "";
              lang = "bash";
              opts = {
                border = {
                  text = {
                    top = "Bash";
                  };
                };
              };
            };
            lua = {
              pattern = "^:%s*lua%s+";
              icon = "";
              lang = "lua";
            };
            help = {
              pattern = "^:%s*he?l?p?%s+";
              icon = "󰋖";
            };
            input = { };
          };
        };

        messages = {
          view = "mini";
          view_error = "mini";
          view_warn = "mini";
        };

        notify.__raw = ''require("snacks").notifier '';

        lsp = {
          override = {
            "vim.lsp.util.convert_input_to_markdown_lines" = true;
            "vim.lsp.util.stylize_markdown" = true;
            # "cmp.entry.get_documentation" = true;
          };

          progress.enabled = true;
          signature.enabled = true;
        };

        popupmenu.backend = "nui";
        # Doesn't support the standard cmdline completions
        # popupmenu.backend = "cmp";

        presets = {
          bottom_search = false;
          command_palette = true;
          long_message_to_split = true;
          inc_rename = true;
          lsp_doc_border = true;
        };

        routes = [
          {
            filter = {
              event = "msg_show";
              kind = "search_count";
            };
            opts = {
              skip = true;
            };
          }
          {
            # skip progress messages from noisy servers
            filter = {
              event = "lsp";
              kind = "progress";
              cond.__raw = ''
                function(message)
                  local client = vim.tbl_get(message.opts, 'progress', 'client')
                  local servers = { 'jdtls' }

                  for index, value in ipairs(servers) do
                      if value == client then
                          return true
                      end
                  end
                end
              '';
            };
            opts = {
              skip = true;
            };
          }

          {
            view = "notify";
            filter = {
              event = "msg_showmode";
            };
          }
        ];

        views = {
          cmdline_popup = {
            position = {
              row = 5;
              col = "50%";
            };
            # size = {
            #   width = 60;
            #   height = "auto";
            # };
            border = {
              style = "single";
            };
          };
          popupmenu = {
            relative = "editor";
            position = {
              row = 8;
              col = "50%";
            };
            # size = {
            #   width = 60;
            #   height = 10;
            # };
            border = {
              style = "rounded";
              padding = [
                0
                1
              ];
            };
            win_options = {
              winhighlight = {
                Normal = "Normal";
                FloatBorder = "DiagnosticInfo";
              };
            };
          };

          confirm = {
            border = {
              style = "single";
              text = {
                top = "";
              };
            };
          };
        };
      };
    };
  };

  keymaps = [
    {
      mode = "n";
      action.__raw = # Lua
        ''
            function()
              require("noice").cmd("history")
            end
        '';

      key = "<leader>sh";
      options.desc = "Noice history";
    }

  ];
}

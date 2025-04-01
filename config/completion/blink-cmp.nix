{
  pkgs,
  system,
  inputs,
  ...
}:
{

  extraPackages = with pkgs; [
    gh
    wordnet
  ];

  extraPlugins = with pkgs.vimPlugins; [
    blink-nerdfont-nvim
    colorful-menu-nvim
  ];

  plugins.blink-cmp-dictionary.enable = true;
  plugins.blink-cmp-git.enable = true;
  plugins.blink-cmp-spell.enable = true;
  plugins.blink-copilot.enable = true;
  plugins.blink-ripgrep.enable = true;
  plugins.blink-emoji.enable = true;
  plugins.blink-compat.enable = true;

  plugins = {
    blink-cmp = {
      enable = true;
      package = inputs.blink-cmp.packages.${system}.default;
      # plugin searches `start` instead of `opt` in pack
      lazyLoad.settings.event = [
        "CmdlineEnter"
        "InsertEnter"
      ];

      settings = {
        completion = {
          ghost_text.enabled = true;
          documentation = {
            auto_show = true;
            window.border = "rounded";
          };
          list.selection = {
            auto_insert = false;
            preselect = false;
          };
          menu = {
            border = "rounded";
            draw = {
              columns = [
                { __unkeyed-1 = "kind_icon"; }
                {
                  __unkeyed-1 = "label";
                  gap = 1;
                }
                { __unkeyed-1 = "source_name"; }
              ];
              components = {
                label = {
                  text.__raw = # Lua
                    ''
                      function(ctx)
                        return require("colorful-menu").blink_components_text(ctx)
                        end
                    '';
                  highlight.__raw = # Lua
                    ''
                      function(ctx)
                          return require("colorful-menu").blink_components_highlight(ctx)
                        end
                    '';
                };
              };
            };
          };
        };
        fuzzy = {
          implementation = "rust";
          prebuilt_binaries = {
            download = false;
          };
        };
        appearance = {
          use_nvim_cmp_as_default = true;
          kind_icons = {
            Copilot = "";
          };
        };
        keymap = {
          preset = "enter";
          "<C-Space>" = [
            "show"
            "show_documentation"
            "hide_documentation"
          ];

          "<C-b>" = [
            "scroll_documentation_up"
            "fallback"
          ];

          "<C-f>" = [
            "scroll_documentation_down"
            "fallback"
          ];

          "<A-Tab>" = [
            "snippet_forward"
            "fallback"
          ];
          "<A-S-Tab>" = [
            "snippet_backward"
            "fallback"
          ];
          "<Tab>" = [
            "select_next"
            "fallback"
          ];
          "<S-Tab>" = [
            "select_prev"
            "fallback"
          ];
        };
        signature = {
          enabled = true;
          window.border = "rounded";
        };
        snippets.preset = "mini_snippets";
        sources = {
          default = [
            # BUILT-IN SOURCES
            "lsp"
            "buffer"
            "snippets"
            "path"

            "easy-dotnet"
            "copilot"
            "dictionary"
            "emoji"
            "git"
            "nerdfont"
            "spell"
          ];
          providers = {
            # BUILT-IN SOURCES
            lsp.score_offset = 4;
            # Community sources
            copilot = {
              name = "copilot";
              module = "blink-copilot";
              async = true;
              # score_offset = 100;
            };
            easy-dotnet = {
              name = "easy-dotnet";
              enabled = true;
              module = "easy-dotnet.completion.blink";
              score_offset = 1000;
              async = true;
            };
            dictionary = {
              name = "Dict";
              module = "blink-cmp-dictionary";
              min_keyword_length = 3;
            };
            emoji = {
              name = "Emoji";
              module = "blink-emoji";
              score_offset = 1;
            };
            git = {
              name = "Git";
              module = "blink-cmp-git";
              enabled = true;
              score_offset = 100;
              should_show_items.__raw = ''
                function()
                  return vim.o.filetype == 'gitcommit' or vim.o.filetype == 'markdown'
                end
              '';
              opts = {
                git_centers = {
                  github = {
                    issue = {
                      on_error.__raw = "function(_,_) return true end";
                    };
                  };
                };
              };
            };
            ripgrep = {
              name = "Ripgrep";
              module = "blink-ripgrep";
              async = true;
              score_offset = 1;
            };
            spell = {
              name = "Spell";
              module = "blink-cmp-spell";
              score_offset = 1;
            };
            nerdfont = {
              module = "blink-nerdfont";
              name = "Nerd Fonts";
              score_offset = 15;
              opts = {
                insert = true;
              };
            };
          };
        };
      };
    };
  };

}

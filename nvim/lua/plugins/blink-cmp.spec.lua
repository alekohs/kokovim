return {
  kokovim.get_plugin_by_repo("saghen/blink.cmp", {
    dependencies = {
      kokovim.get_plugin("mini-nvim", "echasnovski/mini.snippets"),
      kokovim.get_plugin("mini-nvim", "echasnovski/mini.icons"),
      kokovim.get_plugin_by_repo("xzbdmw/colorful-menu.nvim"),
      kokovim.get_plugin_by_repo("giuxtaposition/blink-cmp-copilot"),
    },
    opts = {
      appearance = {
        use_nvim_cmp_as_default = true,
        kind_icons = {
          Copilot = "",
        },
      },
      completion = {
        accept = {
          auto_brackets = { enabled = true },
        },
        ghost_text = {
          enabled = true,
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 250,
          treesitter_highlighting = true,
          window = {
            border = "rounded",
          },
        },
        list = { selection = { preselect = false, auto_insert = false } },
        menu = {
          draw = {
            components = {
              label = {
                text = function(ctx) return require("colorful-menu").blink_components_text(ctx) end,
                highlight = function(ctx) return require("colorful-menu").blink_components_highlight(ctx) end,
              },
              kind_icon = {
                text = function(ctx)
                  local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
                  return kind_icon
                end,
                highlight = function(ctx)
                  local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                  return hl
                end,
              },
              kind = {
                highlight = function(ctx)
                  local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                  return hl
                end,
              },
            },
          },
        },
      },

      keymap = { preset = "default" },
      snippets = { preset = "mini_snippets" },
      signature = {
        enabled = true,
        window = {
          border = "rounded",
          show_documentation = false,
        },
      },
      sources = {
        default = {
          "lsp",
          "buffer",
          "snippets",
          "path",

          -- "copilot",
          -- "dictionary",
          -- "git",
          -- "nerdfont",
          -- "spell",
        },
      },
      -- providers = {
      --   lsp = {
      --     min_keyword_length = 2,
      --     score_offset = 0,
      --   },
      --   path = {
      --     min_keyword_length = 0,
      --   },
      --   snippets = {
      --     min_keyword_length = 2,
      --   },
      --   buffer = {
      --     min_keyword_length = 3,
      --     max_items = 5,
      --   },
      --   -- copilot = {
      --   --   name = "copilot",
      --   --   module = "blink-cmp-copilot",
      --   --   kind = "Copilot",
      --   --   -- score_offset = 100,
      --   --   async = true,
      --   -- },
      --   -- dictionary = {
      --   --   name = "Dict",
      --   --   module = "blink-cmp-dictionary",
      --   --   min_keyword_length = 3,
      --   -- },
      -- },
    },
  }),
}

return {
  kokovim.get_plugin_by_repo("saghen/blink.cmp", {
    dependencies = {
      kokovim.get_plugin("mini-nvim", "echasnovski/mini.snippets"),
      kokovim.get_plugin("mini-nvim", "echasnovski/mini.icons"),
      kokovim.get_plugin_by_repo("giuxtaposition/blink-cmp-copilot"),
      kokovim.get_plugin("colorful-menu-nvim", "xzbdmw/colorful-menu.nvim", {
        opts = {},
        config = function(_, opts) require("colorful-menu").setup(opts) end,
      }),
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
          border = "rounded",
          draw = {
            columns = { { "kind_icon" }, { "label", gap = 1 }, { "source_name" } },
            components = {
              label = {
                text = function(ctx) return require("colorful-menu").blink_components_text(ctx) end,
                highlight = function(ctx) return require("colorful-menu").blink_components_highlight(ctx) end,
              },
            },
          },
        },
      },
      keymap = {
        preset = "enter",
        ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },

        ["<A-Tab>"] = { "snippet_forward", "fallback" },
        ["<A-S-Tab>"] = { "snippet_backward", "fallback" },
        ["<Tab>"] = { "select_next", "fallback" },
        ["<S-Tab>"] = { "select_prev", "fallback" },
      },
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

          "copilot",
          -- "git",
          -- "nerdfont",
          -- "spell",
        },
        providers = {
          lsp = {
            min_keyword_length = 0,
            score_offset = 100,
          },
          path = {
            min_keyword_length = 1,
          },
          snippets = {
            min_keyword_length = 2,
          },
          buffer = {
            min_keyword_length = 2,
            max_items = 5,
          },
          copilot = {
            min_keyword_length = 3,
            name = "copilot",
            module = "blink-cmp-copilot",
            async = true,
          },
        },
      },
    },
  }),
}

local blink_cfg = {
  event = { "InsertEnter", "CmdlineEnter" },
  version = "1.*",
  dependencies = {
    kokovim.get_plugin("mini-nvim", "echasnovski/mini.snippets"),
    kokovim.get_plugin("mini-nvim", "echasnovski/mini.icons"),
  },
  opts = {
    appearance = {
      use_nvim_cmp_as_default = false,
    },
    completion = {
      accept = {
        auto_brackets = { enabled = false },
      },
      ghost_text = { enabled = true },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 500,
        treesitter_highlighting = true,
      },
      list = { selection = { preselect = false, auto_insert = false } },
      menu = {
        border = "rounded",
        draw = {
          columns = { { "kind_icon" }, { "label", gap = 1 }, { "kind" }, { "source_name" } },
          components = {
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
          },
          treesitter = { "lsp" },
        },
      },
    },
    fuzzy = { implementation = "prefer_rust_with_warning" },
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

    cmdline = {
      sources = { "cmdline", "path", "buffer" },
      completion = {
        menu = {
          draw = {
            columns = { { "label" } },
          },
        },
      },
    },
    sources = {
      default = {
        "lsp",
        "buffer",
        "snippets",
        "path",
      },
      providers = {
        lsp = {
          max_items = 10,
          score_offset = 100,
        },
        path = {
          min_keyword_length = 2,
        },
        snippets = {
          min_keyword_length = 2,
        },
        buffer = {
          min_keyword_length = 2,
          max_items = 5,
        },
      },
    },
  },
}

if not kokovim.is_nix then blink_cfg.version = "1.*" end

return {
  kokovim.get_plugin_by_repo("saghen/blink.cmp", blink_cfg),
}

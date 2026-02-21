local blink_cfg = {
  event = "InsertEnter",
  dependencies = {
    kokovim.get_plugin("mini-nvim", "echasnovski/mini.snippets"),
    kokovim.get_plugin("mini-nvim", "echasnovski/mini.icons"),
    kokovim.get_plugin_by_repo("giuxtaposition/blink-cmp-copilot"),
    kokovim.get_plugin_by_repo("Kaiser-Yang/blink-cmp-git"),
    kokovim.get_plugin("colorful-menu-nvim", "xzbdmw/colorful-menu.nvim", {
      config = function()
        require("colorful-menu").setup({
          ls = {
            lua_ls = {
              arguments_hl = "@comment",
            },
            gopls = {
              align_type_to_right = true,
              add_colon_before_type = false,
              preserve_type_when_truncate = true,
            },
            ts_ls = {
              extra_info_hl = "@comment",
            },
            ["rust-analyzer"] = {
              extra_info_hl = "@comment",
              align_type_to_right = true,
              preserve_type_when_truncate = true,
            },
            clangd = {
              extra_info_hl = "@comment",
              align_type_to_right = true,
              import_dot_hl = "@comment",
              preserve_type_when_truncate = true,
            },
            zls = {
              align_type_to_right = true,
            },
            roslyn = {
              extra_info_hl = "@comment",
            },
            dartls = {
              extra_info_hl = "@comment",
            },
            basedpyright = {
              extra_info_hl = "@comment",
            },
            pylsp = {
              extra_info_hl = "@comment",
              arguments_hl = "@comment",
            },
            -- If true, try to highlight "not supported" languages.
            fallback = true,
            fallback_extra_info_hl = "@comment",
          },
          fallback_highlight = "@variable",
        })
      end,
    }),
  },
  opts = {
    appearance = {
      use_nvim_cmp_as_default = false,
      kind_icons = {
        Copilot = "",
      },
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
        window = {
          -- border = "rounded",
        },
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
            label = {
              text = function(ctx) return require("colorful-menu").blink_components_text(ctx) end,
              highlight = function(ctx) return require("colorful-menu").blink_components_highlight(ctx) end,
            },
          },
          treesitter = { "lsp", "copilot" },
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

    sources = {
      default = {
        "lsp",
        "buffer",
        "snippets",
        "path",
        "copilot",
        "git",
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
        copilot = {
          min_keyword_length = 3,
          name = "copilot",
          module = "blink-cmp-copilot",
          async = true,
        },
        git = {
          name = "Git",
          module = "blink-cmp-git",
          enabled = function()
            return vim.tbl_contains({ "gitcommit", "NeogitCommitMessage" }, vim.bo.filetype)
          end,
        },
      },
    },
  },
}

if not kokovim.is_nix then blink_cfg.version = "1.*" end

return {
  kokovim.get_plugin_by_repo("saghen/blink.cmp", blink_cfg),
}

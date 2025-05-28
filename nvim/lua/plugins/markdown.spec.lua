return {

  kokovim.get_plugin_by_repo("toppair/peek.nvim", {
    event = { "VeryLazy" },
    build = "deno task --quiet build:fast",
    opts = {
      auto_load = false,
      app = 'browser',
    },
    keys = {
      {
        "<leader>mp",
        function() require("peek").open() end,
        desc = "Open preview",
      },
      {
        "<leader>mP",
        function() require("peek").close() end,
        desc = "Close preview",
      },

    },

  }),
  kokovim.get_plugin_by_repo("MeanderingProgrammer/render-markdown.nvim", {
    ft = { "markdown", "quarto" },
    dependencies = {
      kokovim.get_plugin_by_repo("nvim-treesitter/nvim-treesitter"),
      kokovim.get_plugin("mini-nvim", "echasnovski/mini.icons"),
    },
    opts = {
      enabled = true,
      bullet = {
        icons = { "◆ ", "• ", "• " },
        right_pad = 1,
      },
      code = {
        above = " ",
        below = " ",
        border = "thick",
        language_pad = 2,
        left_pad = 2,
        position = "right",
        right_pad = 2,
        sign = false,
        width = "block",
      },
      completions = {
        blink = {
          enabled = true,
        },
        lsp = {
          enabled = true,
        },
      },
      heading = {
        border = true,
        icons = {
          "󰲡 ",
          "󰲣 ",
          "󰲥 ",
          "󰲧 ",
          "󰲩 ",
          "󰲫 ",
        },
        position = "inline",
        sign = false,
        width = "full",
      },
      render_modes = { "n", "c", "t" },
      signs = {
        enabled = true,
      },
    },
    keys = {
      {
        "<leader>mt",
        function() require("render-markdown").buf_toggle() end,
        desc = "Toggle markdown render for buffer",
      },
    },
  }),
}

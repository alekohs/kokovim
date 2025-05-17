return {
  kokovim.get_plugin_by_repo("MeanderingProgrammer/render-markdown.nvim", {
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
      render_modes = true,
      signs = {
        enabled = true
      }
    },
    config = function(_, opts) require("render-markdown").setup(opts) end,
    keys = {
      {
        "<leader>mt",
        function() require("render-markdown").buf_toggle() end,
        desc = "Toggle markdown render for buffer",
      },
    },
  }),
}

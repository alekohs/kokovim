return {
    kokovim.get_plugin("mini-nvim", "echasnovski/mini.nvim", {
    version = false,
    dependencies = {
      kokovim.get_plugin_by_repo("JoosepAlviste/nvim-ts-context-commentstring", {
        lazy = false,
        opts = {
          enable_autocmd = false
        }
      })
    },
    config = function()
      -- AI
      require("mini.ai").setup()

      require("mini.comment").setup({
        options = {
          custom_commentstring = function() return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring end,
        },
      })

      -- Icons
      require("mini.icons").setup({
        custom_icons = {
          lsp = {
            Copilot = "X", -- For use with blink.cmp
          },
        },
      })

      -- Move
      require("mini.move").setup({
        reindent_linewise = true,
      })

      -- Pairs
      require("mini.pairs").setup()

      -- Surround
      require("mini.surround").setup({
        mappings = {
          add = "gsa",
          delete = "gsd",
          find = "gsf",
          find_left = "gsF",
          highlight = "gsh",
          replace = "gsr",
          update_n_lines = "gsn",
        },
      })
      -- Snippets
      require("mini.snippets").setup()
    end,
    lazy = false,
  }),
}

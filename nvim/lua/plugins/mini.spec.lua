return {
  kokovim.get_plugin("mini-nvim", "echasnovski/mini.nvim", {
    version = "false",
    config = function()
      -- AI
      require("mini.ai").setup()

      require("mini.comment").setup()

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

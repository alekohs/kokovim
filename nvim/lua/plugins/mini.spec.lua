return {
    kokovim.get_plugin("mini-nvim", "echasnovski/mini.nvim", {
    version = false,
    config = function()
      -- AI
      require("mini.ai").setup()

      require("mini.comment").setup({
        options = {
          custom_commentstring = function()
            local node = vim.treesitter.get_node({ ignore_injections = false })
            if not node then return vim.bo.commentstring end
            local parser = vim.treesitter.get_parser(0)
            if not parser then return vim.bo.commentstring end
            local lang = parser:language_for_range({ node:range() }):lang()
            local ft = vim.treesitter.language.get_filetypes(lang)[1] or lang
            local cs = vim.api.nvim_get_option_value("commentstring", { filetype = ft })
            return (cs ~= "") and cs or vim.bo.commentstring
          end,
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

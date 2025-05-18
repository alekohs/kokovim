return {
  kokovim.get_plugin("copilot.lua", "zbirenbaum/copilot.lua", {
    cmd = "Copilot",
    build = ":Copilot auth",
    event = "BufReadPost",
    opts = {
      suggestion = {
        enabled = false,
        auto_trigger = true,
        hide_during_completion = true,
        keymap = {
          accept = false, -- handled by nvim-cmp / blink.cmp
          next = "<M-]>",
          prev = "<M-[>",
        },
      },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = true,
      },
    },
    config = function(_, opts) require("copilot").setup(opts) end,
  }),
  kokovim.get_plugin("codecompanion.nvim", "olimorris/codecompanion.nvim", {
    dependencies = {
      kokovim.get_plugin("plenary.nvim", "nvim-lua/plenary.nvim"),
      kokovim.get_plugin("nvim-treesitter", "nvim-treesitter/nvim-treesitter"),
    },
    opts = { },
    config = function(_, opts)
      require("codecompanion").setup(opts)
    end,

    keys = {
      { "<leader>ac", "<CMD>CodeCompanionChat<CR>", desc = "Code companion chat" },
      { "<leader>aa", "<CMD>CodeCompanionActions<CR>", desc = "Code companion actions" },
    }
  }),
}

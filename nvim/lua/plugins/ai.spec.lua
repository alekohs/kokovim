local utils = require("utils")

return {
  utils.get_plugin("copilot.lua", "zbirenbaum/copilot.lua", {
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      suggestion = {
        enabled = true,
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
    -- TODO: Authentication is failing for now, can't write to the folder
  }),
  -- utils.get_plugin("CopilotChat.nvim", "CopilotC-Nvim/CopilotChat.nvim", {
  --   dependencies = {
  --     utils.get_plugin("copilot.lua", "zbirenbaum/copilot.lua"),
  --     utils.get_plugin("plenary.nvim", "nvim-lua/plenary.nvim"),
  --   },
  --   build = "make tiktoken",
  --   opts = {
  --     -- See Configuration section for options
  --   },
  -- }),
  utils.get_plugin("codecompanion.nvim", "olimorris/codecompanion.nvim", {
    dependencies = {
      utils.get_plugin("plenary.nvim", "nvim-lua/plenary.nvim"),
      utils.get_plugin("nvim-treesitter", "nvim-treesitter/nvim-treesitter"),
    },
    opts = {
      language = "English",
      opts = {
        -- Set debug logging
        log_level = "DEBUG",
      },
    },
  }),
}

local utils = require("utils")

return utils.getPlugin("which-key.nvim", "folke/which-key", {
  event = "VeryLazy",
  opts = {
    preset = "helix"
  },
  spec = {

  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
})

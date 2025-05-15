local utils = require("utils")
return utils.getPlugin("oil.nvim", "stevearc/oil.nvim", {
  name = "oil.nvim",
  opts = {
    default_file_explorer = true,
  },
  dependencies = {
     utils.getPlugin("mini-nvim", "echasnovski/mini.icons", { opts = {}, config = function()
      require("mini.icons").setup()
    end })
  },
  lazy = false,
})

local utils = require("utils")

return {
  utils.getPlugin("bufferline.nvim", "akinsho/bufferline.nvim.", {
    dependencies = {
      utils.getPlugin("mini-nvim", "echasnovski/mini.icons")
    },
    config = function()
      vim.opt.termguicolors = true
      require("bufferline").setup{}
    end
  }),
}



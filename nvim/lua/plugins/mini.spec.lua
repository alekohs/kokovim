local utils = require("utils")

return {
  -- Icons
  utils.getPlugin("mini-nvim", "echasnovski/mini.icons", {
    opts = {},
    config = function() require("mini.icons").setup() end,
    lazy = false,
  }),
}

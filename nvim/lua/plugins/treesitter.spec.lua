local utils = require("utils")

return {
  utils.getPlugin("nvim-treesitter", "nvim-treesitter/nvim-treesitter", {
    event = { "BufReadPost", "BufNewFile", "VeryLazy" },
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
    opts = {
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = {
        enable = true,
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "gnn",
          node_incremental = "grn",
          scope_incremental = "grc",
          node_decremental = "grm",
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  })

}

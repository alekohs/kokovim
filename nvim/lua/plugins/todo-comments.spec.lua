return kokovim.get_plugin_by_repo("folke/todo-comments.nvim", {
  cmd = { "TodoTrouble", "TodoTelescope" },
  event = "VeryLazy";
  dependencies = { kokovim.get_plugin_by_repo("nvim-lua/plenary.nvim") },
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  },
  config = function(_, opts) require("todo-comments").setup(opts) end,
  keys = {
    { "<leader>st", "<CMD>TodoFzfLua<CR>", desc = "Search todo comments" }
  }
})

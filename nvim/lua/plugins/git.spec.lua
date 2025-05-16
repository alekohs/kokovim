local utils = require("utils")

return {
  utils.get_plugin("lazygit.nvim", "kdheepak/lazygit.nvim", {
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile"
    },
    dependencies = {
      utils.get_plugin("plneary.nvim", "nvim-lua/plenary.nim")
    },
    keys = {
      { "<leader>gg", "<CMD>LazyGit<CR>", desc = "Open LazyGit"}
    }
  }),
}



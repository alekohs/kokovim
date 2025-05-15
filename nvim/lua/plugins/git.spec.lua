local utils = require("utils")

return {
  utils.getPlugin("lazygit.nvim", "kdheepak/lazygit.nvim", {
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile"
    },
    dependencies = {
      utils.getPlugin("plneary.nvim", "nvim-lua/plenary.nim")
    },
    keys = {
      { "<leader>gg", "<CMD>LazyGit<CR>", desc = "Open LazyGit"}
    }
  }),
}



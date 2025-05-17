return {
  kokovim.get_plugin_by_repo("kdheepak/lazygit.nvim", {
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    dependencies = {
      kokovim.get_plugin_by_repo("nvim-lua/plenary.nim"),
    },
    keys = {
      { "<leader>gg", "<CMD>LazyGit<CR>", desc = "Open LazyGit" },
    },
  }),
  kokovim.get_plugin_by_repo("lewis6991/gitsigns.nvim", {
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      current_line_blame = true,
      current_line_blame_opts = {
        delay = 500,
        ignore_blank_lines = true,
        ignore_whitespace = true,
        virt_text = true,
        virt_text_pos = "eol",
      },
      signcolumn = false,
    },
  }),
}

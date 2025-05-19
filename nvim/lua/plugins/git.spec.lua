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
      kokovim.get_plugin_by_repo("nvim-lua/plenary.nvim"),
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
    config = function(_, opts) require("gitsigns").setup(opts) end,
    keys = {
      -- UI
      { "<leader>gb", "<CMD>Gitsigns toggle_current_line_blame<CR>", desc = "Git Blame toggle" },
      { "<leader>gd", "<CMD>Gitsigns toggle_deleted<CR>", desc = "Deleted toggle" },
      { "<leader>gl", "<CMD>Gitsigns toggle_linehl<CR>", desc = "Line Highlight toggle" },
      { "<leader>gn", "<CMD>Gitsigns toggle_numhl<CR>", desc = "Number Highlight toggle" },
      { "<leader>gw", "<CMD>Gitsigns toggle_word_diff<CR>", desc = "Word Diff toggle" },
      { "<leader>gst", "<CMD>Gitsigns toggle_signs<CR>", desc = "Signs toggle" },
      {
        "<leader>gbl",
        function() require("gitsigns").blame_line({ full = true }) end,
        desc = "Git Blame Line",
        silent = true,
      },
      {
        "<leader>gB",
        function() require("gitsigns").blame() end,
        desc = "Git Blame buffer",
        silent = true,
      },
      {
        "<leader>gD",
        function() require("gitsigns").diffthis() end,
        desc = "Diff this",
        silent = true,
      },

      -- Hunks
      {
        "<leader>ghp",
        function()
          if vim.wo.diff then return "<leader>gp" end
          vim.schedule(function() require("gitsigns").prev_hunk() end)
          return "<Ignore>"
        end,
        desc = "Previous hunk",
        silent = true,
        expr = true,
      },
      {
        "<leader>ghn",
        function()
          if vim.wo.diff then return "<leader>gn" end
          vim.schedule(function() require("gitsigns").next_hunk() end)
          return "<Ignore>"
        end,
        desc = "Next hunk",
        silent = true,
        expr = true,
      },
      { "<leader>ghs", "<CMD>Gitsigns stage_hunk<CR>", desc = "Stage hunk", mode = { "n", "v" } },
      { "<leader>ghu", "<CMD>Gitsigns undo_stage_hunk<CR>", desc = "Undo stage hunk" },
      { "<leader>ghr", "<CMD>Gitsigns reset_hunk<CR>", desc = "Reset hunk", mode = { "n", "v" } },
      { "<leader>ghP", "<CMD>Gitsigns preview_hunk<CR>", desc = "Preview hunk" },
      { "<leader>ghp", "<CMD>Gitsigns preview_hunk_inline<CR>", desc = "Preview hunk inline" },

      -- Buffer
      { "<leader>gbs", "<CMD>Gitsigns stage_buffer<CR>", desc = "Stage buffer" },
      { "<leader>gbr", "<CMD>Gitsigns reset_buffer<CR>", desc = "Reset buffer" },
    },
  }),
}

return {
  kokovim.get_plugin_by_repo("sindrets/diffview.nvim", {
    cond = not vim.g.vscode,
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    opts = {
      enhanced_diff_hl = true,
      view = {
        default      = { disable_diagnostics = true },
        file_history = { disable_diagnostics = true },
      },
      hooks = {
        diff_buf_read = function(bufnr)
          vim.bo[bufnr].wrap = true
        end,
      },
      keymaps = {
        diff3 = {
          { "n", "<leader>co", function() require("diffview.actions").conflict_choose("ours")()   end, desc = "Choose ours" },
          { "n", "<leader>ct", function() require("diffview.actions").conflict_choose("theirs")() end, desc = "Choose theirs" },
          { "n", "<leader>cb", function() require("diffview.actions").conflict_choose("base")()   end, desc = "Choose base" },
          { "n", "<leader>ca", function() require("diffview.actions").conflict_choose("all")()    end, desc = "Choose all" },
          { "n", "<leader>cx", function() require("diffview.actions").conflict_choose("none")()   end, desc = "Delete conflict" },
        },
        diff4 = {
          { "n", "<leader>co", function() require("diffview.actions").conflict_choose("ours")()   end, desc = "Choose ours" },
          { "n", "<leader>ct", function() require("diffview.actions").conflict_choose("theirs")() end, desc = "Choose theirs" },
          { "n", "<leader>cb", function() require("diffview.actions").conflict_choose("base")()   end, desc = "Choose base" },
          { "n", "<leader>ca", function() require("diffview.actions").conflict_choose("all")()    end, desc = "Choose all" },
          { "n", "<leader>cx", function() require("diffview.actions").conflict_choose("none")()   end, desc = "Delete conflict" },
        },
      },
    },
    keys = {
      { "<leader>gdo", "<CMD>DiffviewOpen<CR>",             desc = "Open diffview" },
      { "<leader>gdc", "<CMD>DiffviewClose<CR>",            desc = "Close diffview" },
      { "<leader>gdh", "<CMD>DiffviewFileHistory %<CR>",    desc = "File history" },
      { "<leader>gdH", "<CMD>DiffviewFileHistory<CR>",      desc = "Branch history" },
      { "<leader>gdh", "<CMD>'<,'>DiffviewFileHistory<CR>", desc = "Selection history", mode = "v" },
    },
  }),
}

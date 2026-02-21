return {
  kokovim.get_plugin_by_repo("lewis6991/gitsigns.nvim", {
    cond = not vim.g.vscode,
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
      { "]h", function() require("gitsigns").nav_hunk("next") end, desc = "Next hunk" },
      { "[h", function() require("gitsigns").nav_hunk("prev") end, desc = "Prev hunk" },
      { "<leader>ghs", function() require("gitsigns").stage_hunk() end, desc = "Stage hunk" },
      { "<leader>ghs", function() require("gitsigns").stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, mode = "v", desc = "Stage hunk" },
      { "<leader>ghr", function() require("gitsigns").reset_hunk() end, desc = "Reset hunk" },
      { "<leader>ghp", function() require("gitsigns").preview_hunk() end, desc = "Preview hunk" },
      { "<leader>ghS", function() require("gitsigns").stage_buffer() end, desc = "Stage buffer" },
      { "<leader>ghR", function() require("gitsigns").reset_buffer() end, desc = "Reset buffer" },
      { "<leader>ghu", function() require("gitsigns").undo_stage_hunk() end, desc = "Undo stage hunk" },
      {
        "<leader>gB",
        function() require("gitsigns").blame_line({ full = true }) end,
        desc = "Git Blame Line",
        silent = true,
      },
    },
  }),
}

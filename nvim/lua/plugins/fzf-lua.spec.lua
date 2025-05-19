return kokovim.get_plugin_by_repo("ibhagwan/fzf-lua", {
  dependencies = { kokovim.get_plugin("mini-nvim", "echasnovski/mini.icons") },
  config = function(_, opts)
    require("fzf-lua").setup(opts)
    require("fzf-lua").register_ui_select()
  end,
  keys = {
    { "<leader><space>", function() require("fzf-lua").files() end, desc = "Find files" },
    { "<leader>/", function() require("fzf-lua").live_grep() end, desc = "Find live grep" },
    { "<leader>fb", function() require("fzf-lua").buffers() end, desc = "Find buffers" },
    { "<leader>fg", function() require("fzf-lua").git_files() end, desc = "Find git files" },
    { "<leader>fr", function() require("fzf-lua").oldfiles() end, desc = "Find recent files" },

    { "<leader>ssd", function() require("fzf-lua").lsp_document_symbols() end, desc = "Search document symbols" },
    { "<leader>ssw", function() require("fzf-lua").lsp_workspace_symbols() end, desc = "Search workspace symbols" },
    { "<leader>sR", function() require("fzf-lua").registers() end, desc = "Search registers" },
    { "<leader>sh", function() require("fzf-lua").helptags() end, desc = "Search help tags" },
    { "<leader>sm", function() require("fzf-lua").marks() end, desc = "Search marks" },
    { "<leader>sM", function() require("fzf-lua").man_pages() end, desc = "Search man pages" },
    { "<leader>sT", function() require("fzf-lua").tmux() end, desc = "Search tmux buffers" },
    { "<leader>sq", function() require("fzf-lua").quickfix() end, desc = "Search quickfix list" },
  },
})

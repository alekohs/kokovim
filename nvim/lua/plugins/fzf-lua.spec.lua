return kokovim.get_plugin_by_repo("ibhagwan/fzf-lua", {
  opts = {
    files = {
      ignore = { "__virtual%.cs$" },
    },
  },
  dependencies = { kokovim.get_plugin("mini-nvim", "echasnovski/mini.icons") },
  config = function(_, opts)
    require("fzf-lua").setup(opts)
    require("fzf-lua").register_ui_select()

    local picker = require("kokovim.picker")
    vim.keymap.set("n", "<leader>ct", picker.theme_picker, { desc = "Pick a colorscheme" })
  end,
  keys = {
    { "<leader><space>", function() require("fzf-lua").files() end, desc = "Find files" },
    { "<leader>/", function() require("fzf-lua").live_grep() end, desc = "Find live grep" },
    { "<leader>,", function() require("fzf-lua").buffers() end, desc = "Find buffers" },
    { "<leader>fb", function() require("fzf-lua").buffers() end, desc = "Find buffers" },
    { "<leader>fr", function() require("fzf-lua").oldfiles() end, desc = "Find recent files" },
    { "<leader>fw", function() require("fzf-lua").grep_cword() end, desc = "Find word under cursor" },
    { "<leader>fv", function() require("fzf-lua").grep_visual() end, desc = "Find word under visual" },

    {
      "<leader>cd",
      function() require("fzf-lua").lsp_document_diagnostics() end,
      desc = "Document diagnostics",
    },

    {
      "<leader>cD",
      function() require("fzf-lua").lsp_workspace_diagnostics() end,
      desc = "Workspace diagnostics",
    },

    {
      "<leader>cs",
      function() require("fzf-lua").lsp_document_symbols() end,
      desc = "Document symbols",
    },
    {
      "<leader>cS",
      function() require("fzf-lua").lsp_workspace_symbols() end,
      desc = "Workspace symbols",
    },

    { "<leader>gs", function() require("fzf-lua").git_status() end, desc = "Find git status" },
    { "<leader>gf", function() require("fzf-lua").git_files() end, desc = "Find git files" },
    { "<leader>gb", function() require("fzf-lua").git_blame() end, desc = "Find git files" },

    { "<leader>sR", function() require("fzf-lua").registers() end, desc = "Search registers" },
    { "<leader>sh", function() require("fzf-lua").helptags() end, desc = "Search help tags" },
    { "<leader>sm", function() require("fzf-lua").marks() end, desc = "Search marks" },
    { "<leader>sM", function() require("fzf-lua").man_pages() end, desc = "Search man pages" },
    { "<leader>sq", function() require("fzf-lua").quickfix() end, desc = "Search quickfix list" },
  },
})

local ui = require("kokovim.ui")

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
  end,
  keys = {
    { "<leader><space>", function() require("fzf-lua").files() end,     desc = "Find files" },
    { "<leader>/",       function() require("fzf-lua").live_grep() end, desc = "Find live grep" },
    { "<leader>,",       function() require("fzf-lua").buffers() end,   desc = "Find buffers" },
    { "<leader>fb",      function() require("fzf-lua").buffers() end,   desc = "Find buffers" },
    { "<leader>fg",      function() require("fzf-lua").git_files() end, desc = "Find git files" },
    { "<leader>fr",      function() require("fzf-lua").oldfiles() end,  desc = "Find recent files" },

    {
      "<leader>cd",
      function()
        ui.custom_prompt("Search document symbol: ", {}, function(query)
          if query ~= "" then
            require("fzf-lua").lsp_document_symbols({ query = query })
          else
            require("fzf-lua").lsp_document_symbols()
          end
        end)
      end,
      desc = "Search document symbols",
    },
    {
      "<leader>cs",
      function()
        local input = vim.fn.input("Search workspace symbol: ")
        if input ~= "" then require("fzf-lua").lsp_workspace_symbols({ query = input }) end
      end,
      desc = "Search workspace symbols",
    },

    { "<leader>sR", function() require("fzf-lua").registers() end, desc = "Search registers" },
    { "<leader>sh", function() require("fzf-lua").helptags() end,  desc = "Search help tags" },
    { "<leader>sm", function() require("fzf-lua").marks() end,     desc = "Search marks" },
    { "<leader>sM", function() require("fzf-lua").man_pages() end, desc = "Search man pages" },
    { "<leader>sT", function() require("fzf-lua").tmux() end,      desc = "Search tmux buffers" },
    { "<leader>sq", function() require("fzf-lua").quickfix() end,  desc = "Search quickfix list" },
  },
})

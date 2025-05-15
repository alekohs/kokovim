local utils = require("utils")

return utils.getPlugin("fzf-lua", "ibhagwan/fzf-lua", {
  dependencies = { utils.getPlugin("mini-nvim", "echasnovski/mini.icons") },
  config = function(_, opts) require("fzf-lua").setup(opts) end,
  keys = {
    { "<leader><space>", function() require("fzf-lua").files() end, desc = "Find files" },
    { "<leader>/", function() require("fzf-lua").live_grep() end, desc = "Find live grep" },
    { "<leader>fb", function() require("fzf-lua").buffers() end, desc = "Find buffers" },
    { "<leader>fg", function() require("fzf-lua").git_files() end, desc = "Find git files" },
    { "<leader>fr", function() require("fzf-lua").oldfiles() end, desc = "Find recent files" },

    { "<leader>s", function() require("fzf-lua").registers() end, desc = "Search registers" },
    { "<leader>sh", function() require("fzf-lua").helptags() end, desc = "Search buffers" },
    { "<leader>sm", function() require("fzf-lua").marks() end, desc = "Search marks" },
    { "<leader>sM", function() require("fzf-lua").man_pages() end, desc = "Search man pages" },
    { "<leader>sq", function() require("fzf-lua").quickfix() end, desc = "Search quickfix list" },

  }
})

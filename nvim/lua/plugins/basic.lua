return {
  kokovim.get_plugin_by_repo("folke/snacks.nvim", {
    cond = not vim.g.vscode,
    opts = {
      rename = {},
      terminal = {},
      lazygit = {},
      lsp = { enabled = true },
    },
    keys = {
      { "<leader>gg", function() require("snacks").lazygit() end,                   desc = "Lazygit" },
      { "<C-\\>",     function() require("snacks").terminal() end,                  desc = "Toggle terminal", mode = { "n", "t" } },
    },
  }),
  kokovim.get_plugin_by_repo("folke/flash.nvim", {
    event = "VeryLazy",
    vscode = true,
    opts = {},
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  }),

  kokovim.get_plugin("grug-far.nvim", "MagicDuck/grug-far.nvim", {
    opts = { headerMaxWidth = 80 },
    cmd = "GrugFar",
    keys = {
      {
        "<leader>sr",
        function()
          local grug = require("grug-far")
          local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
          grug.open({
            transient = true,
            prefills = {
              filesFilter = ext and ext ~= "" and "*." .. ext or nil,
            },
          })
        end,
        mode = { "n", "v" },
        desc = "Search and Replace",
      },
    },
  }),
}

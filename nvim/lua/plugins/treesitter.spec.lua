return {
  -- Auto-close HTML/JSX tags (uses vim.treesitter directly)
  kokovim.get_plugin_by_repo("windwp/nvim-ts-autotag", {
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      opts = {
        enable_close_on_slash = true,
      },
    },
  }),

  -- Treesitter context (sticky function headers)
  kokovim.get_plugin_by_repo("nvim-treesitter/nvim-treesitter-context", {
    event = { "BufReadPre", "BufNewFile" },
    opts = { mode = "cursor", max_lines = 3 },
    config = function(_, opts)
      local tsc = require("treesitter-context")
      tsc.setup(opts)
      vim.keymap.set("n", "<leader>ut", function() tsc.toggle() end, { desc = "Toggle treesitter context" })
    end,
  }),

  -- Treesitter textobjects (uses vim.treesitter directly)
  kokovim.get_plugin_by_repo("nvim-treesitter/nvim-treesitter-textobjects", {
    branch = "main",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-treesitter-textobjects").setup({
        select = { lookahead = true },
        move = { set_jumps = true },
      })

      -- Select keymaps
      vim.keymap.set({ "x", "o" }, "af", function() require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects") end, { desc = "Select outer function" })
      vim.keymap.set({ "x", "o" }, "if", function() require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects") end, { desc = "Select inner function" })
      vim.keymap.set({ "x", "o" }, "ac", function() require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects") end, { desc = "Select outer class" })
      vim.keymap.set({ "x", "o" }, "ic", function() require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects") end, { desc = "Select inner class" })

      -- Move keymaps
      vim.keymap.set({ "n", "x", "o" }, "]m", function() require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects") end, { desc = "Next function start" })
      vim.keymap.set({ "n", "x", "o" }, "]]", function() require("nvim-treesitter-textobjects.move").goto_next_start("@class.outer", "textobjects") end, { desc = "Next class start" })
      vim.keymap.set({ "n", "x", "o" }, "]d", function() require("nvim-treesitter-textobjects.move").goto_next_start("@conditional.outer", "textobjects") end, { desc = "Next conditional start" })
      vim.keymap.set({ "n", "x", "o" }, "]M", function() require("nvim-treesitter-textobjects.move").goto_next_end("@function.outer", "textobjects") end, { desc = "Next function end" })
      vim.keymap.set({ "n", "x", "o" }, "][", function() require("nvim-treesitter-textobjects.move").goto_next_end("@class.outer", "textobjects") end, { desc = "Next class end" })
      vim.keymap.set({ "n", "x", "o" }, "[f", function() require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects") end, { desc = "Prev function start" })
      vim.keymap.set({ "n", "x", "o" }, "[[", function() require("nvim-treesitter-textobjects.move").goto_previous_start("@class.outer", "textobjects") end, { desc = "Prev class start" })
      vim.keymap.set({ "n", "x", "o" }, "[d", function() require("nvim-treesitter-textobjects.move").goto_previous_start("@conditional.outer", "textobjects") end, { desc = "Prev conditional start" })
      vim.keymap.set({ "n", "x", "o" }, "[F", function() require("nvim-treesitter-textobjects.move").goto_previous_end("@function.outer", "textobjects") end, { desc = "Prev function end" })
      vim.keymap.set({ "n", "x", "o" }, "[]", function() require("nvim-treesitter-textobjects.move").goto_previous_end("@class.outer", "textobjects") end, { desc = "Prev class end" })
    end,
  }),
}

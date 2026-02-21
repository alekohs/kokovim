return {
  kokovim.get_plugin_by_repo("folke/noice.nvim", {
    cond = not vim.g.vscode,
    event = "VeryLazy",
    dependencies = {
      kokovim.get_plugin_by_repo("MunifTanjim/nui.nvim"),
      kokovim.get_plugin_by_repo("rcarriga/nvim-notify", {
        opts = {
          render = "wrapped-compact",
        },
        config = function(_, opts)
          require("notify").setup(opts)
          -- vim.notify = notify
        end,
      }),
    },
    opts = {
      cmdline = {
        view = "cmdline",
        format = {
          search_down = {
            view = "cmdline",
          },
          search_up = {
            view = "cmdline",
          },
        },
      },
      lsp = {
        progress = {
          enabled = false,
        },
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
        },
      },
      routes = {
        -- Skip entirely
        {
          filter = { event = "msg_show", kind = { "shell_out", "shell_err" } },
          opts = { skip = true },
        },
        {
          filter = { event = "msg_show", kind = "search_count" },
          opts = { skip = true },
        },

        -- Mini (lower-right corner, no popup)
        {
          filter = { event = "msg_showmode" },
          view = "mini",
        },
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+L, %d+B" },
              { find = "; after #%d+" },
              { find = "; before #%d+" },
              { find = "%d+ more lines" },
              { find = "%d+ fewer lines" },
              { find = "yanked" },
              { find = "written" },           -- file saved
              { find = "%d+ line" },          -- substitution counts
              { find = "search hit" },         -- search wrap
              { find = "No information" },     -- LSP hover miss
              { find = "already at" },         -- undo/redo boundary
              { find = "E486:" },              -- pattern not found
            },
          },
          view = "mini",
        },
        {
          filter = {
            event = "notify",
            any = {
              { find = "Initializing Roslyn" },
              { find = "Roslyn project initialization complete" },
            },
          },
          view = "mini",
        },
      },
      presets = {
        bottom_search = true,
        command_palette = false,
        long_message_to_split = true,
        inc_rename = true,
      },
      notify = {
        enabled = true,
        view = "notify",
      },
    },
    config = function(_, opts)
      -- HACK: noice shows messages from before it was enabled,
      -- but this is not ideal when Lazy is installing plugins,
      -- so clear the messages in this case.
      if vim.o.filetype == "lazy" then vim.cmd([[messages clear]]) end
      require("noice").setup(opts)
    end,
    keys = {
      { "<leader>sn", "", desc = "+noice" },
      {
        "<S-Enter>",
        function() require("noice").redirect(vim.fn.getcmdline()) end,
        mode = "c",
        desc = "Redirect Cmdline",
      },
      { "<leader>snl", function() require("noice").cmd("last") end, desc = "Noice Last Message" },
      { "<leader>snh", function() require("noice").cmd("history") end, desc = "Noice History" },
      { "<leader>sna", function() require("noice").cmd("all") end, desc = "Noice All" },
      { "<leader>snd", function() require("noice").cmd("dismiss") end, desc = "Dismiss All" },
      { "<leader>snt", function() require("noice").cmd("pick") end, desc = "Noice Picker (Telescope/FzfLua)" },
      {
        "<c-f>",
        function()
          if not require("noice.lsp").scroll(4) then return "<c-f>" end
        end,
        silent = true,
        expr = true,
        desc = "Scroll Forward",
        mode = { "i", "n", "s" },
      },
      {
        "<c-b>",
        function()
          if not require("noice.lsp").scroll(-4) then return "<c-b>" end
        end,
        silent = true,
        expr = true,
        desc = "Scroll Backward",
        mode = { "i", "n", "s" },
      },
    },
  }),
}

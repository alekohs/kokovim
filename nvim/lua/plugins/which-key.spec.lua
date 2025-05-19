return kokovim.get_plugin("which-key.nvim", "folke/which-key", {
  event = "VeryLazy",
  opts_exted = { "spec" },
  opts = {
    preset = "helix",
    spec = {
      {
        mode = { "n", "v" },
        { "<leader><tab>", group = "tabs", icon = "" },
        { "<leader>a", group = "ai" },
        { "<leader>c", group = "code" },
        { "<leader>d", group = "debug" },
        { "<leader>dp", group = "profiler" },
        { "<leader>f", group = "file/find" },
        { "<leader>g", group = "git" },
        { "<leader>gh", group = "hunks", icon = " " },
        { "<leader>q", group = "quit/session" },
        { "<leader>s", group = "search" },
        { "<leader>u", group = "ui", icon = { icon = "󰙵 ", color = "cyan" } },
        { "<leader>x", group = "diagnostics/quickfix", icon = { icon = "󱖫 ", color = "green" } },
        { "[", group = "prev" },
        { "]", group = "next" },
        { "g", group = "goto" },
        { "gs", group = "surround" },
        { "z", group = "fold" },
        {
          "<leader>b",
          group = "buffer",
          expand = function() return require("which-key.extras").expand.buf() end,
        },
        {
          "<leader>w",
          group = "windows",
          proxy = "<c-w>",
          expand = function() return require("which-key.extras").expand.win() end,
        },
        -- better descriptions
        { "gx", desc = "Open with system app" },
      },
    },
  },
  keys = {
    {
      "<leader>?",
      function() require("which-key").show({ global = false }) end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
})

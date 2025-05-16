local utils = require("utils")

return {
  utils.get_plugin("blink.cmp", "saghen/blink.cmp", {
    opts = {
      keymap = { preset = "default" },
      sources = {
        default = {
          "lsp",
          "buffer",
          "snippets",
          "path",
        },

        -- "copilot", "dictionary", "emoji", "git",
        -- "nerdfont", "spell"
      },
    },
  }),
}

return kokovim.get_plugin_by_repo("hat0uma/csvview.nvim", {
  cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },
  ft = { "csv", "tsv" },
  opts = {
    view = {
      display_mode = "border",
      sticky_header = { enabled = true },
    },
    keymaps = {
      textobject_field_inner = { "if", mode = { "o", "x" } },
      textobject_field_outer = { "af", mode = { "o", "x" } },
      jump_next_field_start = { "<Tab>", mode = { "n", "v" } },
      jump_prev_field_start = { "<S-Tab>", mode = { "n", "v" } },
    },
  },
  init = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "csv", "tsv" },
      callback = function(ev)
        vim.keymap.set("n", "<leader>cv", "<cmd>CsvViewToggle<cr>", {
          buffer = ev.buf,
          desc = "Toggle CsvView",
        })
      end,
    })
  end,
})

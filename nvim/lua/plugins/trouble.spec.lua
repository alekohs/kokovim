return kokovim.get_plugin_by_repo("folke/trouble.nvim", {
  cmd = { "Trouble" },
  config = function()
    require("trouble").setup({
      modes = {
        diagnostics = {
          filter = function(items)
            return vim.tbl_filter(function(item) return not string.match(item.basename, [[%__virtual.cs$]]) end, items)
          end,
        },
        preview_float = {
          mode = "diagnostics",
          preview = {
            type = "float",
            relative = "editor",
            border = "rounded",
            title = "Preview",
            title_pos = "center",
            position = { 0, -2 },
            size = {
              width = 0.3,
              height = 0.3,
            },
            zindex = 200,
          },
        },
        lsp = {
          win = {
            position = "right",
          },
        },
        symbols = {
          win = {
            position = "right",
            size = 0.3,
          },
        },
      },
    })
  end,
  keys = {
    { "<leader>xx", "<CMD>Trouble diagnostics toggle<CR>", desc = "Diagnostics toggle" },
    { "<leader>xX", "<CMD>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Buffer Diagnostics toggle" },
    { "<leader>cS", "<CMD>Trouble symbols toggle<CR>", desc = "Symbols toggle" },
    { "<leader>xl", "<CMD>Trouble lsp toggle<CR>", desc = "LSP Definitions / references / ... toggle" },
    { "<leader>xL", "<CMD>Trouble loclist toggle<CR>", desc = "Location List toggle" },
    { "<leader>xQ", "<CMD>Trouble qflist toggle<CR>", desc = "Quickfix List toggle" },
    {
      "[q",
      function()
        if require("trouble").is_open() then
          require("trouble").prev({ skip_groups = true, jump = true })
        else
          local ok, err = pcall(vim.cmd.cprev)
          if not ok then vim.notify(err, vim.log.levels.ERROR) end
        end
      end,
      desc = "Previous trouble/quickfix item",
    },
    {
      "]q",
      function()
        if require("trouble").is_open() then
          require("trouble").next({ skip_groups = true, jump = true })
        else
          local ok, err = pcall(vim.cmd.cnext)
          if not ok then vim.notify(err, vim.log.levels.ERROR) end
        end
      end,
      desc = "Next trouble/quickfix item",
    },
  },
})

return {
  kokovim.get_plugin_by_repo("akinsho/bufferline.nvim", {
    event = "VeryLazy",
    dependencies = {
      kokovim.get_plugin("mini-nvim", "echasnovski/mini.icons"),
    },
    keys = {
      { "<leader>bd", "<Cmd>bd<CR>", desc = "Delete current buffer" },
      { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "BufferLine - Toggle Pin" },
      { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "BufferLine - Delete Non-Pinned Buffers" },
      { "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "BufferLine - Delete Buffers to the Right" },
      { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "BufferLine - Delete Buffers to the Left" },
      { "<leader>bf", "<Cmd>BufferLinePick<CR>", desc = "BufferLine - Pick buffer" },
      { "<leader>bF", "<Cmd>BufferLinePickClose<CR>", desc = "BufferLine - Pick and close buffer" },
      { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "BufferLine - Prev buffer" },
      { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "BufferLine - Next buffer" },
      { "[b", "<cmd>BufferLineMovePrev<cr>", desc = "BufferLine - Move buffer prev" },
      { "]b", "<cmd>BufferLineMoveNext<cr>", desc = "BufferLine - Move buffer next" },
    },
    opts = {
      options = {
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
          local s = ""
          for e, n in pairs(diagnostics_dict) do
            local sym = e == "error" and " " or (e == "warning" and " " or "")
            if sym ~= "" then s = s .. " " .. n .. sym end
          end
          return s
        end,
        always_show_bufferline = false,
        separator_style = "padded_slant",
        offsets = {
          {
            filetype = "neo-tree",
            text = "Neo-tree",
            highlight = "Directory",
            text_align = "left",
          },
          {
            filetype = "Otree",
          },
          {
            filetype = "snacks_layout_box",
          },
        },
      },
    },
  }),
}

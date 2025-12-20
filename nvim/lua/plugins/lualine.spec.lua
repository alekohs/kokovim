return {
  kokovim.get_plugin("lualine.nvim", "nvim-lualine/lualine.nvim", {
    event = "VeryLazy",
    dependencies = {
      kokovim.get_plugin("mini-nvim", "echasnovski/mini.icons"),
      kokovim.get_plugin_by_repo("SmiteshP/nvim-navic"),
      kokovim.get_plugin_by_repo("folke/noice.nvim"),
    },
    config = function()
      local function navic_cond()
        local buf_size_limit = 1024 * 1024 -- 1MB
        local lines = vim.api.nvim_buf_line_count(0)
        if vim.api.nvim_buf_get_offset(0, lines) > buf_size_limit then return false end
        return require("nvim-navic").is_available()
      end

      require("lualine").setup({
        options = {
          icons_enabled = true,
          globalstatus = true,
          theme = "auto", --kokovim.get_colorscheme(),
          disabled_filetypes = {
            statusline = {
              "startify",
              "neo-tree",
              "copilot-chat",
              "ministarter",
              "Avante",
              "AvanteInput",
              "trouble",
              "dapui_scopes",
              "dapui_breakpoints",
              "dapui_stacks",
              "dapui_watches",
              "dapui_console",
              "dashboard",
              "snacks_dashboard",
              "snacks_layout_box",
            },
            winbar = {
              "dap-repl",
              "neotest-summary",
            },
          },
        },

        sections = {
          lualine_a = { "mode" },
          lualine_b = {
            { "branch", icon = "" },
            { "diff", symbols = { added = " ", modified = " ", removed = " " } },
          },
          lualine_c = {
            {
              "diagnostics",
              sources = { "nvim_lsp" },
              symbols = {
                error = " ",
                warn = " ",
                info = " ",
                hint = "󰝶 ",
              },
            },
            {
              "navic",
              cond = navic_cond,
            },
          },
          lualine_x = {
            {
              require("noice").api.statusline.mode.get,
              cond = require("noice").api.statusline.mode.has,
              color = { fg = "#f6c177" },
            },
            {
              "searchcount",
              color = { fg = "#eb6f92" },
            },
            "filetype",
            { "filename", path = 1 },
          },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },

        winbar = {
          lualine_c = {
            {
              "navic",
              cond = navic_cond,
            },
          },
        },
      })
    end,
  }),
}

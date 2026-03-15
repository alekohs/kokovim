return {
  kokovim.get_plugin("lualine.nvim", "nvim-lualine/lualine.nvim", {
    cond = not vim.g.vscode,
    event = "VeryLazy",
    dependencies = {
      kokovim.get_plugin("mini-nvim", "echasnovski/mini.icons"),
      kokovim.get_plugin_by_repo("SmiteshP/nvim-navic"),
    },
    config = function()
      local function navic_cond()
        local buf_size_limit = 1024 * 1024 -- 1MB
        local lines = vim.api.nvim_buf_line_count(0)
        if vim.api.nvim_buf_get_offset(0, lines) > buf_size_limit then return false end
        return require("nvim-navic").is_available()
      end

      local function location_progress()
        local line = vim.fn.line(".")
        local col = vim.fn.col(".")
        local pct = math.floor(line / vim.fn.line("$") * 100)
        return string.format("%d:%d · %d%%%%", line, col, pct)
      end

      require("lualine").setup({
        options = {
          icons_enabled = true,
          globalstatus = true,
          theme = "auto", --kokovim.get_colorscheme(),
          section_separators = { left = "", right = "" },
          component_separators = { left = "│", right = "│" },
          disabled_filetypes = {
            statusline = {
              "copilot-chat",
              "dapui_scopes",
              "dapui_breakpoints",
              "dapui_stacks",
              "dapui_watches",
              "dapui_console",
              "snacks_dashboard",
              "snacks_layout_box",
            },
            winbar = {
              "copilot-chat",
              "dap-repl",
              "dapui_scopes",
              "dapui_breakpoints",
              "dapui_stacks",
              "dapui_watches",
              "dapui_console",
              "snacks_dashboard",
              "snacks_layout_box",
              "neotest-summary",
              "qf",
              "help",
            },
          },
        },

        sections = {
          lualine_a = { "mode" },
          lualine_b = {
            { "branch", icon = "" },
            { "diff", symbols = { added = kokovim.icons.git.added .. " ", modified = kokovim.icons.git.modified .. " ", removed = kokovim.icons.git.removed .. " " } },
          },
          lualine_c = {},
          lualine_x = {
            {
              function()
                local reg = vim.fn.reg_recording()
                if reg ~= "" then return " rec @" .. reg end
                return ""
              end,
              color = { fg = "#9ccfd8" },
            },
            {
              "searchcount",
              color = { fg = "#eb6f92" },
            },
          },
          lualine_y = { { location_progress } },
          lualine_z = {
            {
              "encoding",
              cond = function() return vim.opt.fileencoding:get() ~= "utf-8" end,
            },
            {
              "fileformat",
              cond = function() return vim.bo.fileformat ~= "unix" end,
              symbols = { unix = "LF", dos = "CRLF", mac = "CR" },
            },
          },
        },

        winbar = {
          lualine_b = {
            {
              "filename",
              path = 1,
              symbols = { modified = " ●", readonly = " ", unnamed = "[No Name]" },
            },
          },
          lualine_c = {
            {
              "navic",
              cond = navic_cond,
            },
          },
          lualine_x = {
            {
              "diagnostics",
              sources = { "nvim_lsp" },
              symbols = {
                error = kokovim.icons.diagnostics.error .. " ",
                warn  = kokovim.icons.diagnostics.warn  .. " ",
                hint  = kokovim.icons.diagnostics.hint  .. " ",
                info  = kokovim.icons.diagnostics.info  .. " ",
              },
            },
          },
          lualine_y = { "filetype" },
          lualine_z = {},
        },

        inactive_winbar = {
          lualine_b = {
            {
              "filename",
              path = 1,
              symbols = { modified = " ●", readonly = " ", unnamed = "[No Name]" },
            },
          },
          lualine_y = { "filetype" },
        },
      })

      vim.api.nvim_create_autocmd({ "RecordingEnter", "RecordingLeave" }, {
        callback = require("lualine").refresh,
      })
    end,
  }),
}

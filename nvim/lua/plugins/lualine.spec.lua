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

      local function lsp_clients()
        local clients = vim.lsp.get_clients({ bufnr = 0 })
        if #clients == 0 then return "" end
        local names = {}
        for _, c in ipairs(clients) do
          table.insert(names, c.name)
        end
        return " " .. table.concat(names, " ")
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
              "neo-tree",
              "copilot-chat",
              "ministarter",
              "Avante",
              "AvanteInput",
              "trouble",
              "dap-repl",
              "dapui_scopes",
              "dapui_breakpoints",
              "dapui_stacks",
              "dapui_watches",
              "dapui_console",
              "dashboard",
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
          lualine_c = {
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
          lualine_x = {
            {
              function()
                local reg = vim.fn.reg_recording()
                if reg ~= "" then return " @" .. reg end
                return ""
              end,
              color = { fg = "#eb6f92" },
            },
            {
              "searchcount",
              color = { fg = "#eb6f92" },
            },
          },
          lualine_y = { "location" },
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
              function() return require("lsp-progress").progress() end,
              color = { fg = "#c4a7e7" },
            },
            {
              lsp_clients,
              color = { fg = "#c4a7e7" },
              cond = function() return #vim.lsp.get_clients({ bufnr = 0 }) > 0 end,
            },
          },
          lualine_y = { "filetype" },
          lualine_z = { "progress" },
        },

        inactive_winbar = {
          lualine_b = {
            {
              "filename",
              path = 1,
              symbols = { modified = " ●", readonly = " ", unnamed = "[No Name]" },
            },
          },
        },
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "LspProgressStatusUpdated",
        callback = require("lualine").refresh,
      })
    end,
  }),
}

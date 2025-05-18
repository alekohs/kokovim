local disabled_files = {
  "Enums.hs",
  "all-packages.nix",
  "hackage-packages.nix",
  "generated.nix",
}

local disabled_filetypes = {
  "bash",
  "dockerfile",
  "sh",
  "tmux",
}

local function disable_treesitter_features(bufnr)
  local filetype = vim.api.nvim_get_option_value("filetype", { buf = bufnr })
  local fname = vim.api.nvim_buf_get_name(bufnr)
  local short_name = vim.fn.fnamemodify(fname, ":t")
  return vim.tbl_contains(disabled_files, short_name) or vim.tbl_contains(disabled_filetypes, filetype)
end

local ensure_installed = kokovim.is_nix and {}
  or {
    "bash",
    "c",
    "diff",
    "go",
    "html",
    "lua",
    "luadoc",
    "markdown",
    "markdown_inline",
    "python",
    "query",
    "vim",
    "vimdoc",
  }

return {
  kokovim.get_plugin("nvim-treesitter", "nvim-treesitter/nvim-treesitter", {
    event = { "BufReadPost", "BufNewFile", "VeryLazy" },
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    dependencies = {
      kokovim.get_plugin_by_repo("nvim-treesitter/nvim-treesitter-refactor"),
    },
    lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
    opts = {
      auto_install = not kokovim.is_nix,
      ensure_installed = ensure_installed,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { "sh", "bash", "dockerfile", "org" },
        disable = function(lang, buf)
          if disable_treesitter_features(buf) then
            vim.notify("Treesitter disabled by file/filetype.")
            return true
          end

          if vim.api.nvim_buf_line_count(buf) > 1000 then
            vim.notify("Treesitter disabled due to line limit passed 1000 < " .. vim.api.nvim_buf_line_count(buf))
            return true
          end

          return false
        end,
      },
      indent = {
        enable = true,
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "gnn",
          node_incremental = "grn",
          scope_incremental = "grc",
          node_decremental = "grm",
        },
      },
      playground = {
        enable = true,
        disable = {},
        updatetime = 25,
        persist_queries = false,
      },
      refactor = {
        highlight_definitions = {
          enable = true,
          clear_on_cursor_move = true,
        },
        highlight_current_scope = { enable = true },
        smart_rename = {
          enable = true,
          keymaps = {
            smart_rename = "grr",
          },
        },
        navigation = {
          enable = true,
        },
      },
    },
    config = function(_, opts) require("nvim-treesitter.configs").setup(opts) end,
  }),
  kokovim.get_plugin_by_repo("nvim-treesitter/nvim-treesitter-context", {
    event = { "BufReadPre", "BufNewFile" },
    opts = function()
      local tsc = require("treesitter-context")
      vim.keymap.set("n", "<leader>ut", function() tsc.enable() end, { desc = "Toggle tree sitter context" })

      -- Snacks.toggle({
      --   name = "Treesitter Context",
      --   get = tsc.enabled,
      --   set = function(state)
      --     if state then
      --       tsc.enable()
      --     else
      --       tsc.disable()
      --     end
      --   end,
      -- }):map("<leader>ut")
      return { mode = "cursor", max_lines = 3 }
    end,
  }),
}

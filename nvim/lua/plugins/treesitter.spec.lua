local utils = require("utils")
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

local ensure_installed = utils.isNix and {}
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
  utils.get_plugin("nvim-treesitter", "nvim-treesitter/nvim-treesitter", {
    event = { "BufReadPost", "BufNewFile", "VeryLazy" },
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
    opts = {
      auto_install = not utils.isNix,
      ensure_installed = ensure_installed,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { "sh", "bash", "dockerfile", "org" },
        disable = function(_, buf)
          if disable_treesitter_features(buf) then
            vim.notify("Treesitter disabled by file/filetype.")
            return true
          end
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
    },
    config = function(_, opts) require("nvim-treesitter.configs").setup(opts) end,
  }),
}

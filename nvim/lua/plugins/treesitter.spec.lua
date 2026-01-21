local disabled_files = {
  "Enums.hs",
  "all-packages.nix",
  "hackage-packages.nix",
  "generated.nix",
}

local disabled_filetypes = {
  "tmux",
}

local function disable_treesitter_features(_, bufnr)
  local filetype = vim.api.nvim_get_option_value("filetype", { buf = bufnr })
  local fname = vim.api.nvim_buf_get_name(bufnr)
  local short_name = vim.fn.fnamemodify(fname, ":t")
  return vim.tbl_contains(disabled_files, short_name) or vim.tbl_contains(disabled_filetypes, filetype)
end

-- Parsers to install (only used when not running with nix)
local parsers = {
  "arduino",
  "angular",
  "bash",
  "c",
  "c_sharp",
  "css",
  "diff",
  "fish",
  "git_config",
  "git_rebase",
  "gitcommit",
  "gitattributes",
  "gitignore",
  "go",
  "html",
  "http",
  "javascript",
  "jsdoc",
  "json",
  "lua",
  "luadoc",
  "make",
  "markdown",
  "markdown_inline",
  "nix",
  "powershell",
  "proto",
  "python",
  "query",
  "razor",
  "regex",
  "rust",
  "scss",
  "sql",
  "terraform",
  "tmux",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "xml",
  "zig",
}

-- Set treesitter grammars to runtimepath if running with nix
if kokovim.is_nix then
  local plugins_folder = require("kokovim.plugin").get_plugin_folder()
  vim.opt.runtimepath:append(plugins_folder .. "nvim-treesitter-grammars")
end

return {
  -- Main treesitter plugin (master branch for compatibility)
  kokovim.get_plugin_by_repo("nvim-treesitter/nvim-treesitter", {
    branch = "master",
    event = { "BufReadPost", "BufNewFile" },
    build = not kokovim.is_nix and ":TSUpdate" or nil,
    dependencies = {
      kokovim.get_plugin_by_repo("windwp/nvim-ts-autotag", {
        opts = {
          opts = {
            enable_close_on_slash = true,
          },
        },
      }),
    },
    opts = {
      ensure_installed = not kokovim.is_nix and parsers or {},
      highlight = {
        enable = true,
        disable = disable_treesitter_features,
      },
      indent = {
        enable = true,
        disable = disable_treesitter_features,
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  }),

  -- Treesitter context (sticky function headers)
  kokovim.get_plugin_by_repo("nvim-treesitter/nvim-treesitter-context", {
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      kokovim.get_plugin_by_repo("nvim-treesitter/nvim-treesitter"),
    },
    opts = { mode = "cursor", max_lines = 3 },
    config = function(_, opts)
      local tsc = require("treesitter-context")
      tsc.setup(opts)
      vim.keymap.set("n", "<leader>ut", function()
        tsc.toggle()
      end, { desc = "Toggle treesitter context" })
    end,
  }),

  -- Treesitter textobjects (master branch for compatibility)
  kokovim.get_plugin_by_repo("nvim-treesitter/nvim-treesitter-textobjects", {
    branch = "master",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      kokovim.get_plugin_by_repo("nvim-treesitter/nvim-treesitter"),
    },
    opts = {
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]m"] = "@function.outer",
            ["]]"] = "@class.outer",
            ["]d"] = "@conditional.outer",
          },
          goto_next_end = {
            ["]M"] = "@function.outer",
            ["]["] = "@class.outer",
          },
          goto_previous_start = {
            ["[f"] = "@function.outer",
            ["[["] = "@class.outer",
            ["[d"] = "@conditional.outer",
          },
          goto_previous_end = {
            ["[F"] = "@function.outer",
            ["[]"] = "@class.outer",
          },
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  }),
}

local disabled_files = {
  "Enums.hs",
  "all-packages.nix",
  "hackage-packages.nix",
  "generated.nix",
}

local disabled_filetypes = {
  -- "dockerfile",
  -- "sh",
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
  kokovim.get_plugin_by_repo("nvim-treesitter/nvim-treesitter", {
    event = { "BufReadPost", "BufNewFile", "VeryLazy" },
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    dependencies = {
      kokovim.get_plugin_by_repo("windwp/nvim-ts-autotag", { lazy = false }),
    },
    lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
    opts = {
      auto_install = not kokovim.is_nix,
      ensure_installed = ensure_installed,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { "sh", "bash", "dockerfile", "org" },
        disable = function(lang, buf)
          local limit = 10000
          if disable_treesitter_features(buf) then
            vim.notify("Treesitter disabled by file/filetype.")
            return true
          end

          if vim.api.nvim_buf_line_count(buf) > limit then
            vim.notify("Treesitter disabled due to line limit passed " .. limit .. " < " .. vim.api.nvim_buf_line_count(buf))
            return true
          end

          return false
        end,
      },
      autotag = {
        enable = true,
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
    dependencies = {
      kokovim.get_plugin_by_repo("nvim-treesitter/nvim-treesitter"),
    },
    opts = function()
      local tsc = require("treesitter-context")
      vim.keymap.set("n", "<leader>ut", function() tsc.enable() end, { desc = "Toggle tree sitter context" })
      return { mode = "cursor", max_lines = 3 }
    end,
  }),
  kokovim.get_plugin_by_repo("nvim-treesitter/nvim-treesitter-refactor", {
    dependencies = {
      kokovim.get_plugin_by_repo("nvim-treesitter/nvim-treesitter"),
    },
  }),
  kokovim.get_plugin_by_repo("nvim-treesitter/nvim-treesitter-textobjects", {
    dependencies = {
      kokovim.get_plugin_by_repo("nvim-treesitter/nvim-treesitter"),
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup({
        textobjects = {
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              ["]m"] = { query = "@function.outer", desc = "Next function start" },
              ["]]"] = { query = "@class.outer", desc = "Next class start" },

              -- You can use regex matching (i.e. lua pattern) and/or pass a list in a "query" key to group multiple queries.
              ["]o"] = "@loop.*",
              ["]s"] = { query = "@local.scope", query_group = "locals", desc = "Next scope" },
              ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
            },
            goto_next_end = {
              ["]M"] = { query = "@function.outer", desc = "Go to next function end" },
              ["]["] = { query = "@class.outer", desc = "Go to next class end" },
            },
            goto_previous_start = {
              ["[f"] = { query = "@function.outer", desc = "Go to previous function start" },
              ["[["] = { query = "@class.outer", desc = "Go to previous class start" },
            },
            goto_previous_end = {
              ["[F"] = { query = "@function.outer", desc = "Go to previous function end" },
              ["[]"] = { query = "@class.outer", desc = "Go to previous class end" },
            },
            -- Below will go to either the start or the end, whichever is closer.
            -- Use if you want more granular movements
            -- Make it even more gradual by adding multiple queries and regex.
            goto_next = {
              ["]d"] = { query = "@conditional.outer", desc = "" },
            },
            goto_previous = {
              ["[d"] = { query = "@conditional.outer", desc = "" },
            },
          },
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ["af"] = { query = "@function.outer", desc = "Select outer part of a function" },
              ["if"] = { query = "@function.inner", desc = "Select inner part of a function" },
              ["ac"] = { query = "@class.outer", desc = "Selecter outer part of a class" },
              -- You can optionally set descriptions to the mappings (used in the desc parameter of
              -- nvim_buf_set_keymap) which plugins like which-key display
              ["ic"] = { query = "@class.inner", desc = "Select inner part of a class" },
              -- You can also use captures from other query groups like `locals.scm`
              ["as"] = { query = "@local.scope", query_group = "locals", desc = "Select language scope" },
            },
            -- You can choose the select mode (default is charwise 'v')
            --
            -- Can also be a function which gets passed a table with the keys
            -- * query_string: eg '@function.inner'
            -- * method: eg 'v' or 'o'
            -- and should return the mode ('v', 'V', or '<c-v>') or a table
            -- mapping query_strings to modes.
            selection_modes = {
              ["@parameter.outer"] = "v", -- charwise
              ["@function.outer"] = "V", -- linewise
              ["@class.outer"] = "<c-v>", -- blockwise
            },
            -- If you set this to `true` (default is `false`) then any textobject is
            -- extended to include preceding or succeeding whitespace. Succeeding
            -- whitespace has priority in order to act similarly to eg the built-in
            -- `ap`.
            --
            -- Can also be a function which gets passed a table with the keys
            -- * query_string: eg '@function.inner'
            -- * selection_mode: eg 'v'
            -- and should return true or false
            include_surrounding_whitespace = true,
          },
        },
      })
    end,
  }),
}

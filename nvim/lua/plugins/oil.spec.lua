return {
  kokovim.get_plugin_by_repo("stevearc/oil.nvim", {
    name = "oil.nvim",
    opts = {
      default_file_explorer = true,
      delete_to_trash = true,
      view_options = {
        show_hidden = true,
        natural_order = true,
      },
      float = {
        padding = 4,
        -- max_width and max_height can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
        max_width = 0.6,
        max_height = 0.6,
        border = "rounded",
        win_options = {
          winblend = 0,
        },
        preview_split = "auto",
        override = function(conf) return conf end,
      },
      win_options = {
        wrap = true,
        signcolumn = "yes:2",
      },
      keymaps = {
        ["?"] = { "actions.show_help", mode = "n" },
        ["<CR>"] = "actions.select",
        ["<C-s>"] = { "actions.select", opts = { vertical = true } },
        ["<C-h>"] = { "actions.select", opts = { horizontal = true } },
        ["<C-t>"] = { "actions.select", opts = { tab = true } },
        ["<C-p>"] = "actions.preview",
        ["<C-c>"] = { "actions.close", mode = "n" },
        ["<C-l>"] = "actions.refresh",
        ["-"] = { "actions.parent", mode = "n" },
        ["_"] = { "actions.open_cwd", mode = "n" },
        ["`"] = { "actions.cd", mode = "n" },
        ["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
        ["gs"] = { "actions.change_sort", mode = "n" },
        ["gx"] = "actions.open_external",
        ["<S-h>"] = { "actions.toggle_hidden", mode = "n" },
        ["g\\"] = { "actions.toggle_trash", mode = "n" },
        ["gr"] = {
          callback = function()
            local oil = require("oil")
            local prefills = { paths = oil.get_current_dir() }
            local grug = require("grug-far")

            if not grug.has_instance("explorer") then
              grug.open({
                instanceName = "explorer",
                prefills = prefills,
                staticTitle = "Find and Replace from Explorer",
              })
            else
              grug.get_instance("explorer"):open()
              grug.get_instance("explorer"):update_input_values(prefills, false)
            end
          end,
          desc = "Search in directory",
        },
      },
    },
    dependencies = {
      kokovim.get_plugin("mini-nvim", "echasnovski/mini.icons"),
    },
    -- config = function(_, opts) require("oil").setup(opts) end,
    keys = {
      {
        "<leader>o",
        "<CMD>Oil --float<CR>",
        desc = "Open oil",
      },
    },
    lazy = false,
  }),
  kokovim.get_plugin_by_repo("refractalize/oil-git-status.nvim", {
    dependencies = { kokovim.get_plugin_by_repo("stevearc/oil.nvim") },
    opts = {
      symbols = {
        index = {
          ["A"] = kokovim.icons.git.added,
          ["M"] = kokovim.icons.git.modified,
          ["D"] = kokovim.icons.git.removed,
          ["R"] = kokovim.icons.git.renamed,
          ["C"] = kokovim.icons.git.added,
          ["U"] = kokovim.icons.git.unmerged,
          ["?"] = kokovim.icons.git.untracked,
          ["!"] = kokovim.icons.git.ignored,
        },
        working_tree = {
          ["A"] = kokovim.icons.git.added,
          ["M"] = kokovim.icons.git.modified,
          ["D"] = kokovim.icons.git.removed,
          ["R"] = kokovim.icons.git.renamed,
          ["C"] = kokovim.icons.git.added,
          ["U"] = kokovim.icons.git.unmerged,
          ["?"] = kokovim.icons.git.untracked,
          ["!"] = kokovim.icons.git.ignored,
        },
      },
    },
  }),
  kokovim.get_plugin("oil-lsp-diagnostics-nvim", "JezerM/oil-lsp-diagnostics.nvim", {
    dependencies = { kokovim.get_plugin_by_repo("stevearc/oil.nvim") },
    opts = {
      diagnostic_symbols = {
        error = " " .. kokovim.icons.diagnostics.error,
        warn  = " " .. kokovim.icons.diagnostics.warn,
        hint  = " " .. kokovim.icons.diagnostics.hint,
        info  = " " .. kokovim.icons.diagnostics.info,
      },
    },
  }),
  kokovim.get_plugin_by_repo("A7Lavinraj/fyler.nvim", {
    dependencies = { kokovim.get_plugin("mini-nvim", "echasnovski/mini.icons") },
    opts = {
      views = {
        delete_to_trash = true
      }
    }
  }),
}

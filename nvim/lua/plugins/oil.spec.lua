return {
  kokovim.get_plugin("otree-nvim", "Eutrius/Otree.nvim", {
    dependencies = {
      kokovim.get_plugin_by_repo("stevearc/oil.nvim", {
        name = "oil.nvim",
        opts = {
          default_file_explorer = true,
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
          keymaps = {
            ["g?"] = { "actions.show_help", mode = "n" },
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
            -- ["gs"] = { "actions.change_sort", mode = "n" },
            ["gx"] = "actions.open_external",
            ["<S-h>"] = { "actions.toggle_hidden", mode = "n" },
            ["g\\"] = { "actions.toggle_trash", mode = "n" },
            ["gs"] = {
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
    },
    lazy = false,
    config = function() require("Otree").setup() end,
    keys = {
      {
        "<leader>fo",
        ":Otree<CR>",
        desc = "Open OTree",
      },
    },
  }),
}

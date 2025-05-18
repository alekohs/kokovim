return {
  kokovim.get_plugin_by_repo("nvimdev/dashboard-nvim", {
    event = "VimEnter",
    opts = {
      theme = "hyper",
      config = {
        week_header = {
          enable = true,
        },
      },
    },
    config = function(_, opts) require("dashboard").setup(opts) end,
    dependencies = {
      kokovim.get_plugin("mini-nvim", "echasnovski/mini.icons"),
    },
  }),
}

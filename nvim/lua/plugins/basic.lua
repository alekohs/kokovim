return {
  kokovim.get_plugin_by_repo("wakatime/vim-wakatime", { lazy = false }),
  kokovim.get_plugin_by_repo("xiyaowong/transparent.nvim", { lazy = false }),
  kokovim.get_plugin("rose-pine", "rose-pine/neovim", {
    name = "rose-pine",
    ops = {
      variant = "main",
      dark_variant = "main",
      dim_inactive_windows = false,
      extend_background_behind_borders = true,
      highlight_groups = {
        ["@parameter"] = { italic = false },
        ["@property"] = { italic = false },
        ["@variable"] = { italic = false },
        ["@variable.builtin"] = { italic = false },
        ["@variable.parameter"] = { italic = false },
        ["@variable.parameter.builtin"] = { italic = false },
      },
    },
    config = function(_, opts)
      require("rose-pine").setup(opts)
      vim.cmd("colorscheme rose-pine")
    end,
  }),
  kokovim.get_plugin_by_repo("zerochae/endpoint.nvim", {
    cmd = { "Endpoint", "EndpointRefresh" },
    config = function()
      require("endpoint").setup()
    end,
  }),
}

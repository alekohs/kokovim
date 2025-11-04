return {
  kokovim.get_plugin_by_repo("zenbones-theme/zenbones.nvim", {
    dependencies = { kokovim.get_plugin_by_repo("rktjmp/lush.nvim") },
    lazy = false,
    priority = 1000,
  }),
  kokovim.get_plugin("rose-pine", "rose-pine/neovim", {
    name = "rose-pine",
    lazy = false,
    opts = {
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
  }),
  kokovim.get_plugin_by_repo("wnkz/monoglow.nvim", {
    lazy = false,
    priority = 1000,
    opts = {},
  }),
}

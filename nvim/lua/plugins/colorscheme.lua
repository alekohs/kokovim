return {
  kokovim.get_plugin_by_repo("zenbones-theme/zenbones.nvim", {
    cond = not vim.g.vscode,
    dependencies = { kokovim.get_plugin_by_repo("rktjmp/lush.nvim") },
    lazy = false,
    priority = 1000,
  }),

  kokovim.get_plugin_by_repo("gbprod/nord.nvim", {
    cond = not vim.g.vscode,
    lazy = false,
    priority = 1000,
  }),
  kokovim.get_plugin("catppuccin-nvim", "catppuccin/nvim", {
    cond = not vim.g.vscode,
    name = "catppuccin",
    lazy = false,
    priority = 1000,
  }),

  kokovim.get_plugin("rose-pine", "rose-pine/neovim", {
    cond = not vim.g.vscode,
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
    cond = not vim.g.vscode,
    lazy = false,
    priority = 1000,
    opts = {},
  }),
}

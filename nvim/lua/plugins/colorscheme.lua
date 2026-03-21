return {
  kokovim.get_plugin("rose-pine", "rose-pine/neovim", {
    cond = not vim.g.vscode,
    name = "rose-pine",
    lazy = false,
    opts = {
      variant = "main",
      dark_variant = "main",
      dim_inactive_windows = false,
      extend_background_behind_borders = true,
      styles = {
        transparency = true,
      },
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
}

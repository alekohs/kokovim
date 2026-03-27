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
      palette = {
        main = {
          base = "#141416",
          surface = "#242426",
          overlay = "#3e3e42",
          muted = "#908f92",
          subtle = "#6e6e72",
          text = "#e0e0e4",
          highlight_low = "#1c1c1e",
          highlight_med = "#3e3e42",
          highlight_high = "#504f54",
        },
      },
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

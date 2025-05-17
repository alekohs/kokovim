return kokovim.get_plugin("rose-pine", "rose-pine/neovim", {
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
})

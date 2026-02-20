return {
  kokovim.get_plugin_by_repo("nvimdev/dashboard-nvim", {
    cond = not vim.g.vscode,
    event = "VimEnter",
    opts = {
      theme = "hyper",
      config = {
        week_header = {
          enable = true,
        },
        project = {
          action = function(path) require("fzf-lua").files({ cwd = path }) end,
        },
        shortcut = {
          {
            icon = " ",
            icon_hl = "@variable",
            desc = "Files",
            group = "Label",
            action = function() require("fzf-lua").files() end,
            key = "f",
          },
          {
            desc = " LazyGit",
            group = "DiagnosticHint",
            action = "LazyGit",
            key = "a",
          },
          {
            desc = " dotfiles",
            group = "Number",
            action = function() require("fzf-lua").files({ cwd = "~/.config" }) end,
            key = "d",
          },
        },
      },
    },
    config = function(_, opts) require("dashboard").setup(opts) end,
    dependencies = {
      kokovim.get_plugin("mini-nvim", "echasnovski/mini.icons"),
    },
  }),
}

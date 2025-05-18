return kokovim.get_plugin_by_repo("danymat/neogen", {
  opts = {
    snippet_engine = "mini",
    languages = {
      cs = {
        template = {
          annotation_convention = "xmldoc"
        }
      }
    }
  },
  config = function(_, opts)
    require("neogen").setup(opts)
  end,
  keys = {
    { "<leader>cn", "<CMD>Neogen<CR>", desc = "Generate annotation" },
  }
})

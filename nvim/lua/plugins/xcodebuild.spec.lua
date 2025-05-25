return kokovim.get_plugin_by_repo("wojciech-kulik/xcodebuild.nvim", {
  cond = kokovim.is_darwin,
  dependencies = {
    kokovim.get_plugin_by_repo("MunifTanjim/nui.nvim"),
    kokovim.get_plugin_by_repo("nvim-tree/nvim-tree.lua"),
    kokovim.get_plugin_by_repo("stevearc/oil.nvim"),
    kokovim.get_plugin_by_repo("nvim-treesitter/nvim-treesitter"),
    kokovim.get_plugin_by_repo("folke/snacks.nvim"),
  },
  opts = {
    integrations = {
      nvim_tree = {
        enabled = false;
      }
    }
  }
})

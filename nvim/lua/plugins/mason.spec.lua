if kokovim.is_nix then return {} end

return {
  kokovim.get_plugin_by_repo("mason-org/mason.nvim", {
    opts = {
      registries = {
        "github:mason-org/mason-registry",
        "github:Crashdummyy/mason-registry",
      },
    },
    config = function(_, opts) require("mason").setup(opts) end,
  }),
  kokovim.get_plugin_by_repo("mason-org/mason-lspconfig.nvim", {
    opts = {
      ensure_installed = {
        "biome",
        "lua_ls",
        "vimls",
      }
          },
    dependencies = {
  -- kokovim.get_plugin_by_repo("mason-org/mason.nvim")
  -- kokovim.get_plugin_by_repo("neovim/nvim-lspconfig"")

    },
  }),

}

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
}

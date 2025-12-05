-- Return empty if dotnet is not installed
if vim.fn.executable("dotnet") == 0 then return {} end

return {
  kokovim.get_plugin_by_repo("seblyng/roslyn.nvim", {
    ft = { "cs", "razor" },
    opts = {
      broad_search = false,
      silent = false,
    },
  }),
}

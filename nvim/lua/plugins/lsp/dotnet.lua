-- Return empty if dotnet is not installed
if vim.fn.executable("dotnet") == 0 then return {} end

-- Register razor filetype early so lazy.nvim can trigger on ft = "razor"
vim.filetype.add({
  extension = {
    razor = "razor",
    cshtml = "razor",
  },
})

local common = require("plugins.lsp.common")

-- Settings must go through vim.lsp.config, not through plugin opts
-- roslyn.setup() only handles plugin-level options (filewatching, broad_search, etc.)
vim.lsp.config("roslyn", {
  on_attach = common.on_attach,
  capabilities = common.capabilities(),
  settings = {
    ["csharp|completion"] = {
      dotnet_provide_regex_completions = true,
      dotnet_show_completion_items_from_unimported_namespaces = true,
      dotnet_show_name_completion_suggestions = true,
    },
    ["csharp|formatting"] = {
      dotnet_organize_imports_on_format = true,
    },
    ["csharp|symbol_search"] = {
      dotnet_search_reference_assemblies = true,
    },
    ["csharp|inlay_hints"] = {
      csharp_enable_inlay_hints_for_implicit_object_creation = true,
      csharp_enable_inlay_hints_for_implicit_variable_types = true,
      csharp_enable_inlay_hints_for_lambda_parameter_types = true,
      csharp_enable_inlay_hints_for_types = true,
      dotnet_enable_inlay_hints_for_indexer_parameters = true,
      dotnet_enable_inlay_hints_for_literal_parameters = true,
      dotnet_enable_inlay_hints_for_object_creation_parameters = true,
      dotnet_enable_inlay_hints_for_other_parameters = true,
      dotnet_enable_inlay_hints_for_parameters = true,
      dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
      dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
      dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
    },
    ["csharp|code_lens"] = {
      dotnet_enable_references_code_lens = false,
      dotnet_enable_tests_code_lens = false,
    },
    ["csharp|background_analysis"] = {
      dotnet_analyzer_diagnostics_scope = "openFiles",
      dotnet_compiler_diagnostics_scope = "openFiles",
    },
  },
})

return {
  kokovim.get_plugin_by_repo("seblyng/roslyn.nvim", {
    ft = { "cs", "razor" },
    opts = {
      broad_search = true,
      silent = false,
      filewatching = "off",
    },
  }),
}

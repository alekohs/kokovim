local utils = require("kokovim.utils")
local paths = utils.get_packages_path({ "roslyn", "rzls" }, ":")

local function remove_bin_suffix(str) return str:gsub("/bin$", "") end

local cmd = kokovim.is_nix
    and {
      vim.fs.joinpath(paths.roslyn, "Microsoft.CodeAnalysis.LanguageServer"),
      "--logLevel=Information",
      "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()),
      "--stdio",
      "--razorSourceGenerator="
        .. vim.fs.joinpath(remove_bin_suffix(paths.rzls), "lib", "rzls", "Microsoft.CodeAnalysis.Razor.Compiler.dll"),
      "--razorDesignTimePath=" .. vim.fs.joinpath(
        remove_bin_suffix(paths.rzls),
        "lib",
        "rzls",
        "Targets",
        "Microsoft.NET.Sdk.Razor.DesignTime.targets"
      ),
    }
  or {
    "dotnet",
    vim.fs.joinpath(paths.roslyn, "Microsoft.CodeAnalysis.LanguageServer.dll"),
    "--stdio",
    "--logLevel=Information",
    "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()),
    "--razorSourceGenerator=" .. vim.fs.joinpath(paths.roslyn, "Microsoft.CodeAnalysis.Razor.Compiler.dll"),
    "--razorDesignTimePath=" .. vim.fs.joinpath(paths.rzls, "Targets", "Microsoft.NET.Sdk.Razor.DesignTime.targets"),
  }

return {
  kokovim.get_plugin_by_repo("seblyng/roslyn.nvim", {
    ft = "cs",
    dependencies = {
      kokovim.get_plugin_by_repo("tris203/rzls.nvim", {
        config = function()
          require("rzls").setup({
            path = vim.fs.joinpath(paths.rzls, "rzls"),
            config = true,
          })
        end,
      }),
      kokovim.get_plugin_by_repo("GustavEikaas/easy-dotnet.nvim", {
        opts = {
          test_runner = {
            viewmode = "float",
          },
          -- picker = "snacks"
        },
        config = function(_, opts) require("easy-dotnet").setup(opts) end,
      }),
    },
    opts = {
      broad_search = true,
      config = {
        cmd = cmd,
        handlers = require("rzls.roslyn_handlers"),
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
            dotnet_enable_references_code_lens = true,
            dotnet_enable_tests_code_lens = true,
          },
        },
      },
    },
  }),
}

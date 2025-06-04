local utils = require("kokovim.utils")
local paths = utils.get_packages_path({ "roslyn", "rzls" }, ":")

local function remove_bin_suffix(str) return str:gsub("/bin$", "") end

local cmd = kokovim.is_nix
    and {
      vim.fs.joinpath(paths.roslyn, "Microsoft.CodeAnalysis.LanguageServer"),
      "--logLevel=Information",
      "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()),
      "--stdio",
      -- TODO: This code makes bin/ obj/ folders in non-project folders. Assembly info duplicates
      -- "--razorSourceGenerator=" .. vim.fs.joinpath(remove_bin_suffix(paths.rzls), "lib", "rzls", "Microsoft.CodeAnalysis.Razor.Compiler.dll"),
      -- "--razorDesignTimePath="
      --   .. vim.fs.joinpath(remove_bin_suffix(paths.rzls), "lib", "rzls", "Targets", "Microsoft.NET.Sdk.Razor.DesignTime.targets"),
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

---@class LineRange
---@field line integer
---@field character integer

---@class EditRange
---@field start LineRange
---@field end LineRange

---@class TextEdit
---@field newText string
---@field range EditRange

---@param edit TextEdit
local function apply_vs_text_edit(edit)
  local bufnr = vim.api.nvim_get_current_buf()
  local start_line = edit.range.start.line
  local start_char = edit.range.start.character
  local end_line = edit.range["end"].line
  local end_char = edit.range["end"].character

  local newText = string.gsub(edit.newText, "\r", "")
  local lines = vim.split(newText, "\n")

  local placeholder_row = -1
  local placeholder_col = -1

  -- placeholder handling
  for i, line in ipairs(lines) do
    local pos = string.find(line, "%$0")
    if pos then
      lines[i] = string.gsub(line, "%$0", "", 1)
      placeholder_row = start_line + i - 1
      placeholder_col = pos - 1
      break
    end
  end

  vim.api.nvim_buf_set_text(bufnr, start_line, start_char, end_line, end_char, lines)

  if placeholder_row ~= -1 and placeholder_col ~= -1 then
    local win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_cursor(win, { placeholder_row + 1, placeholder_col })
  end
end

return {
  kokovim.get_plugin_by_repo("seblyng/roslyn.nvim", {
    ft = { "cs", "razor" },
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
      }),
    },
    config = function()
      vim.lsp.config("roslyn", {
        cmd = cmd,
        capabilities = {
          textDocument = {
            _vs_onAutoInsert = { dynamicRegistration = false },
          },
        },
        handlers = {
          -- require("rzls.roslyn_handlers"),
          ["textDocument/_vs_onAutoInsert"] = function(err, result, _)
            if err or not result then return end
            apply_vs_text_edit(result._vs_textEdit)
          end,
        },
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
      })

      vim.lsp.enable("roslyn")
    end,
    init = function() vim.filetype.add({ extension = { razor = "razor", cshtml = "razor" } }) end,
  }),
}

local utils = require("kokovim.utils")
local paths = utils.get_packages_path({ "roslyn", "rzls" }, ":")

-- Return empty if dotnet is not installed
if vim.fn.executable("dotnet") == 0 then return {} end

local function remove_bin_suffix(str) return str:gsub("/bin$", "") end
local function get_rzls_path() return (paths.rzls == nil or paths.rzls == "") and vim.fn.expand("$MASON/packages/rzls/libexec") or paths.rzls end
local function get_cmd()
  paths.rzls = get_rzls_path()

  local cmd = kokovim.is_nix
      and {
        vim.fs.joinpath(paths.roslyn, "Microsoft.CodeAnalysis.LanguageServer"),
        "--logLevel=Information",
        "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()),
        "--stdio",
        "--razorSourceGenerator=" .. vim.fs.joinpath(remove_bin_suffix(paths.rzls), "lib", "rzls", "Microsoft.CodeAnalysis.Razor.Compiler.dll"),
        "--razorDesignTimePath="
          .. vim.fs.joinpath(remove_bin_suffix(paths.rzls), "lib", "rzls", "Targets", "Microsoft.NET.Sdk.Razor.DesignTime.targets"),
      }
    or {
      "roslyn",
      "--stdio",
      "--logLevel=Information",
      "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()),
      "--razorSourceGenerator=" .. vim.fs.joinpath(paths.rzls, "Microsoft.CodeAnalysis.Razor.Compiler.dll"),
      "--razorDesignTimePath=" .. vim.fs.joinpath(paths.rzls, "Targets", "Microsoft.NET.Sdk.Razor.DesignTime.targets"),
      "--extension",
      vim.fs.joinpath(paths.rzls, "RazorExtension", "Microsoft.VisualStudioCode.RazorExtension.dll"),
    }

  return cmd
end

---@param edit string
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
      kokovim.get_plugin_by_repo("SmiteshP/nvim-navbuddy", {
        dependencies = {
          kokovim.get_plugin_by_repo("SmiteshP/nvim-navic"),
          kokovim.get_plugin_by_repo("MunifTanjim/nui.nvim"),
        },
        opts = { lsp = { auto_attach = true } },
      }),
      kokovim.get_plugin_by_repo("tris203/rzls.nvim", {
        config = function()
          local rzls_path = get_rzls_path()
          require("rzls").setup({
            path = vim.fs.joinpath(rzls_path, "rzls"),
            config = true,
          })
        end,
      }),
      kokovim.get_plugin_by_repo("GustavEikaas/easy-dotnet.nvim", {
        opts = {
          test_runner = {
            viewmode = "float",
          },
          picker = "fzf",
        },
      }),
    },
    config = function()
      local navic = require("nvim-navic")
      local navbuddy = require("nvim-navbuddy")

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities({}, false))
      capabilities = vim.tbl_deep_extend("force", capabilities, {
        textDocument = {
          foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
          },
        },
      })

      -- Shared `on_attach` if you want keymaps, etc.
      local on_attach = function(client, bufnr)
        if client.server_capabilities.documentSymbolProvider then
          vim.notify("Attach navic to buffer", vim.log.levels.DEBUG)
          navic.attach(client, bufnr)
          navbuddy.attach(client, bufnr)
        end

        vim.keymap.set("n", "<leader>ck", function() require("nvim-navbuddy").open() end, { desc = "Lsp Navigation", buffer = bufnr })
        vim.keymap.set("n", "<leader>xdc", function()
          local cwd = vim.fn.getcwd()
          local cmd = string.format("find %s -type d \\( -name bin -o -name obj \\) -exec rm -rf {} +", cwd)
          vim.fn.system(cmd)
          print("Deleted all bin/ and obj/ folders under " .. cwd)
        end, { desc = "Dotnet - clean" })
      end

      vim.lsp.config("roslyn", {
        cmd = get_cmd(),
        on_attach = on_attach,
        capabilities = capabilities,
        handlers = {
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

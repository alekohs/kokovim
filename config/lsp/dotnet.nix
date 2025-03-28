{
pkgs,
config,
lib,
...
}:
{
  options.lsp.dotnet = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable dotnet lsp";
    };

    version = lib.mkOption {
      type = lib.types.int;
      default = 9;
      description = "Dotnet version";
    };
  };

  config =
    let
      cfg = config.lsp.dotnet;
    in
    {


      extraPlugins = lib.optionals cfg.enable [
        pkgs.vimPlugins.roslyn-nvim
        pkgs.vimPlugins.rzls-nvim
      ];

      extraConfigLua =
        lib.mkIf cfg.enable # Lua
          ''
            require('lz.n').load({
                    "seblyng/roslyn.nvim",
                    ft = { "cs", "razor" },
                    before = function()
                      vim.filetype.add { extension = { razor = 'razor', cshtml = 'razor', }, }
                    end,
                    after = function()

                      require('roslyn').setup({
                      exe = vim.fs.joinpath("${pkgs.roslyn-ls}" --[[@as string]], 'bin', 'Microsoft.CodeAnalysis.LanguageServer'),
                      args = {
                      '--stdio',
                      '--logLevel=Information',
                      '--extensionLogDirectory=' .. vim.fs.dirname(vim.lsp.get_log_path()),
                      '--razorSourceGenerator=' .. vim.fs.joinpath("${pkgs.roslyn-ls}", 'lib', 'roslyn-ls', 'Microsoft.CodeAnalysis.Razor.Compiler.dll'),
                      '--razorDesignTimePath=' .. vim.fs.joinpath("${pkgs.rzls}", 'lib', 'rzls', 'Targets', 'Microsoft.NET.Sdk.Razor.DesignTime.targets'),
                        },
                        ---@diagnostic disable-next-line: missing-fields
                        config = {
                          handlers = require 'rzls.roslyn_handlers',
                          settings = {
                            ['csharp|inlay_hints'] = {
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
                            ['csharp|code_lens'] = {
                              dotnet_enable_references_code_lens = true,
                            },
                          },
                        },
                      })

                          require('rzls').setup()

                    end
                  })

          '';

    };
}

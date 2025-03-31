{
  system,
  pkgs,
  ...
}:
{
  imports = [
    # ./ale.nix
    ./dotnet.nix
    ./rust.nix
    ./xcodebuild.nix
  ];

  plugins.lsp = {
    enable = true;
    lazyLoad.settings.ft = [ "*" ];

    inlayHints = true;

    servers = {
      bashls.enable = true;
      clangd.enable = true;
      cmake.enable = true;
      dockerls.enable = true;
      html.enable = true;
      gopls.enable = true;
      jsonls.enable = true;
      lua_ls.enable = true;
      marksman.enable = true;
      nixd.enable = true;
      pylsp.enable = true;
      ruff.enable = true;
      sqls.enable = true;
      tailwindcss.enable = true;
      ts_ls.enable = true;
      yamlls.enable = true;

      sourcekit.enable = pkgs.stdenv.isDarwin;
    };

    keymaps = {
      silent = true;
      extra = [
        {
          action.__raw = ''vim.lsp.buf.format'';
          mode = [
            "n"
            "v"
          ];
          key = "<leader>cf";
          options = {
            silent = true;
            buffer = false;
            desc = "Format selection";
          };
        }
        {
          action.__raw = ''function() Snacks.picker.lsp_definitions() end'';
          # action.__raw = "vim.lsp.buf.definition";
          mode = "n";
          key = "gd";
          options = {
            silent = true;
            buffer = false;
            #has = "definition";
            desc = "Goto definition";
          };
        }
        {
          action.__raw = ''function() Snacks.picker.lsp_declarations() end'';
          # action.__raw = "vim.lsp.buf.definition";
          mode = "n";
          key = "gD";
          options = {
            silent = true;
            buffer = false;
            desc = "Goto declaration";
          };
        }

        {
          action.__raw = ''function() Snacks.picker.lsp_implementations() end'';
          # action.__raw = "vim.lsp.buf.implementation";
          mode = "n";
          key = "gi";
          options = {
            silent = true;
            buffer = false;
            desc = "Goto Implementations";
          };
        }
        {
          action.__raw = ''function() Snacks.picker.lsp_type_definitions() end'';
          # action.__raw = "vim.lsp.buf.type_definition";
          mode = "n";
          key = "gy";
          options = {
            silent = true;
            buffer = false;
            desc = "Goto T[y]pe Definition";
          };
        }

        {

          action.__raw = ''function() Snacks.picker.lsp_references() end'';
          # action.__raw = "vim.lsp.buf.references";
          mode = "n";
          key = "gr";
          options = {
            silent = true;
            buffer = false;
            desc = "References";
          };
        }

        # Code

        {
          action.__raw = "function() vim.lsp.buf.code_action() end";
          mode = "n";
          options.desc = "Code Action";
          key = "<leader>ca";
        }
        {
          action.__raw = # Lua
            ''
              function()
                vim.lsp.buf.code_action({
                  apply = true,
                  context = {
                    only = { "source" },
                    diagnostics = {},
                  }
                })
              end
            '';
          mode = "n";
          options.desc = "Source Action";
          key = "<leader>cA";
        }

        {
          action.__raw = "function() vim.lsp.codelens.run() end";
          mode = "n";
          options.desc = "Run Codelens";
          key = "<leader>cc";
        }
        {
          action.__raw = "function() vim.lsp.codelens.refresh() end";
          mode = "n";
          options.desc = "Refresh Codelens";
          key = "<leader>cC";
        }

        {
          action.__raw = ''function() return vim.lsp.buf.hover() end '';
          mode = "n";
          options.desc = "Hover";
          key = "K";
        }
        {
          action.__raw = ''function() return vim.lsp.buf.signature_help() end '';
          mode = "n";
          options.desc = "Signature help";
          key = "<leader>gK";
        }

        {
          mode = "i";
          action.__raw = ''function() return vim.lsp.buf.signature_help() end '';
          options.desc = "Signature help";
          key = "<C-k>";
        }
        {
          action.__raw = "vim.lsp.buf.rename";
          mode = "n";
          key = "<leader>cr";
          options.desc = "Rename";
        }
        {
          action.__raw = ''function() Snacks.rename.rename_file() end'';
          mode = "n";
          key = "<leader>cR";
          options.desc = "Rename File";
        }

      ];
    };
  };

  # plugins.lsp-format = {
  #   enable = true;
  #   lazyLoad.settings.ft = [ "nix" ];
  # };

  plugins.lsp-lines = {
    enable = true;
    lazyLoad.settings.ft = [ "*" ];
  };

  plugins.lsp-signature = {
    enable = true;
    lazyLoad.settings.ft = [ "*" ];
  };

}

{ lib, pkgs, ... }:
{
  plugins.conform-nvim = {
    enable = true;
    lazyLoad.settings = {
      cmd = [ "ConformInfo" ];
      event = [ "DeferredUIEnter" ];
    };

    luaConfig.pre = ''
      local slow_format_filetypes = {}
    '';

    settings = {
      # format_on_save = # Lua
      #   ''
      #     function(bufnr)
      #       if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      #         return
      #       end
      #
      #
      #       vim.notify("Global: " .. vim.inspect(vim.g.disable_autoformat) .. " Local: " .. vim.inspect(vim.b[bufnr].disable_autoformat), "debug", {
      #         title = "Conform",
      #         id = "autoformat"
      #       })
      #
      #
      #       if slow_format_filetypes[vim.bo[bufnr].filetype] then
      #          return
      #        end
      #
      #
      #       local function on_format(err)
      #         if err and err:match("timeout$") then
      #           slow_format_filetypes[vim.bo[bufnr].filetype] = true
      #         end
      #       end
      #
      #
      #       vim.notify("Auto format on save", "debug", {
      #         title = "Conform",
      #         id = "auto-format-notify"
      #       })
      #
      #       return { timeout_ms = 200, lsp_fallback = true }, on_format
      #      end
      #   '';
      default_format_opts = {
        lsp_format = "fallback";
      };

      formatters_by_ft = {
        bash = [
          "shellcheck"
          "shellharden"
          "shfmt"
        ];
        cs = [ "csharpier" ];
        javascript = {
          __unkeyed-1 = "prettierd";
          __unkeyed-2 = "prettier";
          timeout_ms = 2000;
          stop_after_first = true;
        };
        json = [ "jq" ];
        lua = [ "stylua" ];
        markdoewn = [ "deno_fmt" ];
        nix = [ "nixfmt" ];
        fish = [ "fish_indent" ];
        "*" = [ "codespell" ];
        "_" = [
          "squeeze_blanks"
          "trim_whitespace"
          "trim_newlines"
        ];
      };

      formatters = {
        codespell.command = lib.getExe pkgs.codespell;
        jq.command = lib.getExe pkgs.jq;
        nixfmt.command = lib.getExe pkgs.nixfmt-rfc-style;
        prettierd.command = lib.getExe pkgs.prettierd;
        shellcheck.command = lib.getExe pkgs.shellcheck;
        shellharden.command = lib.getExe pkgs.shellharden;
        shfmt.command = lib.getExe pkgs.shfmt;
        squeeze_blanks.command = lib.getExe' pkgs.coreutils "cat";
        stylelint.command = lib.getExe pkgs.stylelint;
        stylua.command = lib.getExe pkgs.stylua;
        xmlformat.command = lib.getExe pkgs.xmlformat;
        yamlfmt.command = lib.getExe pkgs.yamlfmt;
      };
    };

  };

  keymaps = [
    {
      mode = "n";
      action = "<CMD>lua require('conform').format()<CR>";
      key = "<leader>cF";
      options.desc = "Format injected language";
    }
    {
      mode = "v";
      action.__raw = # Lua
        ''
          function()
            require("conform").format({
              lsp_fallback = true,
              range = {
                ["start"] = vim.api.nvim_buf_get_mark(0, "<"),
                ["end"] = vim.api.nvim_buf_get_mark(0, ">"),
              }
            })
          end
        '';
      key = "<leader>cF";
      options.desc = "Format injected language";
    }
  ];
}

{
  lib,
  pkgs,
  config,
  ...
}:
{
  extraConfigLua = ''
    local function lint_status()
      local lint = require("lint")
      local bufnr = vim.api.nvim_get_current_buf()
      local linters = lint.linters_by_ft[vim.bo[bufnr].filetype] or {}

      if #linters == 0 then
        return "" -- No linters available for this filetype
      end

      local messages = vim.diagnostic.get(bufnr, { namespace = lint.get_namespace() })
      local count = { errors = 0, warnings = 0 }

      for _, msg in ipairs(messages) do
        if msg.severity == vim.diagnostic.severity.ERROR then
          count.errors = count.errors + 1
        elseif msg.severity == vim.diagnostic.severity.WARN then
          count.warnings = count.warnings + 1
        end end

      if count.errors > 0 then
        return " " .. count.errors
      elseif count.warnings > 0 then
        return " " .. count.warnings
      else
        return " OK"
      end
    end
  '';

  extraPackages = with pkgs; [
    ] ++ lib.optionals pkgs.stdenv.isDarwin [
      swiftlint
    ];
  plugins = {
    lint = {
      enable = true;
      lazyLoad.settings.event = "DeferredUIEnter";

      lintersByFt =
        {
          bash = [ "shellcheck" ];
          c = [ "clangtidy" ];
          cmake = [ "cmakelint" ];
          cpp = [ "clangtidy" ];
          css = lib.mkIf (!config.plugins.lsp.servers.stylelint_lsp.enable) [ "stylelint" ];
          fish = [ "fish" ];
          go = [ "golangcilint" ];
          html = [ "htmlhint" ];
          java = [ "checkstyle" ];
          javascript = lib.mkIf (!config.plugins.lsp.servers.biome.enable) [ "biomejs" ];
          json = [ "jsonlint" ];
          lua = [ "luacheck" ];
          make = [ "checkmake" ];
          markdown = [ "markdownlint" ];
          nix = [ "deadnix" ];
          rust = [ "clippy" ];
          sh = [ "shellcheck" ];
          sql = [ "sqlfluff" ];
          typescript = lib.mkIf (!config.plugins.lsp.servers.biome.enable) [ "biomejs" ];
          yaml = [ "yamllint" ];
        }
        // (
          if pkgs.stdenv.isDarwin then
            {
              swift = [ "swiftlint" ];
            }
          else
            { }
        );

      linters =
        {
          biomejs.cmd = lib.getExe pkgs.biome;
          checkmake.cmd = lib.getExe pkgs.checkmake;
          checkstyle.cmd = lib.getExe pkgs.checkstyle;
          clangtidy.cmd = lib.getExe' pkgs.clang-tools "clang-tidy";
          clippy.cmd = lib.getExe pkgs.rust-analyzer;
          cmakelint.cmd = lib.getExe' pkgs.cmake-format "cmake-lint";
          deadnix.cmd = lib.getExe pkgs.deadnix;
          fish.cmd = lib.getExe pkgs.fish;
          golangcilint.cmd = lib.getExe pkgs.golangci-lint;
          htmlhint.cmd = lib.getExe pkgs.htmlhint;
          jsonlint.cmd = lib.getExe pkgs.nodePackages.jsonlint;
          luacheck.cmd = lib.getExe pkgs.luaPackages.luacheck;
          markdownlint.cmd = lib.getExe pkgs.markdownlint-cli;
          nix.cmd = lib.getExe' pkgs.nix "nix-instantiate";
          pylint.cmd = lib.getExe pkgs.pylint;
          shellcheck.cmd = lib.getExe pkgs.shellcheck;
          sqlfluff.cmd = lib.getExe pkgs.sqlfluff;
          statix.cmd = lib.getExe pkgs.statix;
          stylelint.cmd = lib.getExe pkgs.stylelint;
          yamllint.cmd = lib.getExe pkgs.yamllint;
        }
        // (
          if pkgs.stdenv.isDarwin then
            {
            # TODO: Find why this is throwing an error
              # swiftlint.cmd = lib.getExe pkgs.swiftlint;
            }
          else
            { }
        );
    };
  };
}

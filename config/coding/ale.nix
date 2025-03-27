{
  self,
  pkgs,
  system,
  ...
}:
{
  extraPlugins = [
    self.packages.${system}.ale-nvim
  ];

  extraPackages = with pkgs; [
    deadnix
    nix
    nixfmt-rfc-style
  ];

  extraConfigLua = # Lua
    ''
      require("ale").setup({
        disable_lsp = "auto",
        sign_info = vim.g.symbol_info,
        sign_error = vim.g.symbol_error,
        sign_warning = vim.g.symbol_warn,
        sign_priority = 4,
        open_list = 0,
        echo_msg_format = "%severity% [%linter%] (%code%) - %s",
        lint_on_text_changed = 'always',

        linters = {
          javascript = { "eslint", "prettier" },
          luacheck = { "luacheck" },
          nix = { "dead-nix" },
        },
        fixers = {
          nix = { "nixfmt-rfc-style" },
        },

      })
    '';

  keymaps = [ ];
}

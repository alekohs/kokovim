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
      -- Basic ALE setup
      vim.g.ale_linters_explicit = 1  -- only use explicit linters
      vim.g.ale_linters = {
        ['javascript'] = {'eslint', 'prettier'},
        ['lua'] = {'luacheck'},
        ['nix'] = {'dead-nix'},
      }

      vim.g.ale_fixers = {
        ['nix'] = {'nixfmt'},
      }

      -- vim.g.ale_lint_on_save = 1  -- Lint on save
      vim.g.ale_lint_on_text_changed = 'always'  -- Lint on text change
      -- vim.g.ale_fix_on_save = 1  -- Fix on save
      vim.g.ale_echo_msg_error_str = 'Error:'
      vim.g.ale_echo_msg_warning_str = 'Warning:'
    '';

  keymaps = [ ];
}

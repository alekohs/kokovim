{ lib, ... }:
let
  harpoonFiles = 5;
in
{
  plugins.harpoon = {
    enable = true;
    menu = {
      width.__raw = "vim.api.nvim_win_get_width(0) - 4";
    };
    saveOnToggle = true;
  };

  keymaps =
    [
      {
        mode = "n";
        action.__raw = "require('harpoon.mark').add_file";
        key = "<leader>ha";
        options.desc = "Add file to harpoon";
        options.silent = true;
      }
      {
        mode = "n";
        action.__raw = "require('harpoon.mark').clear_all";
        key = "<leader>hC";
        options.desc = "Clear all marks";
        options.silent = true;
      }

      {
        mode = "n";
        action.__raw = "require('harpoon.ui').toggle_quick_menu";
        key = "<leader>ht";
        options.desc = "Toggle harpoon menu";
        options.silent = true;
      }
      {
        mode = "n";
        action.__raw = "require('harpoon.ui').nav_prev";
        key = "<leader>hb";
        options.desc = "Go to previous harpoon file";
        options.silent = true;
      }

      {
        mode = "n";
        action.__raw = "require('harpoon.ui').nav_next";
        key = "<leader>hn";
        options.desc = "Go to next harpoon file";
        options.silent = true;
      }
    ]
    ++ lib.genList (n: {
      mode = "n";
      action.__raw = ''function() require('harpoon.ui').nav_file(${toString (n + 1)}) end'';
      key = "<leader>h${toString (n + 1)}";
      options.desc = "Navigate to harpoon file ${toString (n + 1)}";
    }) harpoonFiles
    ++ lib.genList (n: {
      mode = "n";
      action.__raw = ''function() require('harpoon.mark').rm_file(${toString (n + 1)}) end'';
      key = "<leader>hr${toString (n + 1)}";
      options.desc = "Remove harpoon mark ${toString (n + 1)}";
    }) harpoonFiles
    ++ lib.genList (n: {
      mode = "n";
      action.__raw = ''function() require('harpoon.ui').nav_file(${toString (n + 1)}) end'';
      key = "<C-${toString (n + 1)}>";
      options.desc = "Navigate to harpoon file ${toString (n + 1)}";
    }) harpoonFiles;
}

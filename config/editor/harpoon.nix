{ lib, ... }:
let
  harpoonFiles = 9;
in
{
  plugins.harpoon = {
    enable = true;
    settings = {
      settings = {
        # menu = { width.__raw = "vim.api.nvim_win_get_width(0) - 4"; };
        sync_on_ui_close = true;
        key.__raw = ''
          function()
            return vim.loop.cwd()  -- This makes Harpoon 2 project-specific
          end
        '';
        save_on_toggle = true;
      };
    };
  };

  extraConfigLua = ''
    require('harpoon'):extend({
      UI_CREATE = function(cx)
        vim.keymap.set("n", "<C-v>", function()
          harpoon.ui:select_menu_item({ vsplit = true })
        end, { buffer = cx.bufnr })

        vim.keymap.set("n", "<C-x>", function()
          harpoon.ui:select_menu_item({ split = true })
        end, { buffer = cx.bufnr })

        vim.keymap.set("n", "<C-t>", function()
          harpoon.ui:select_menu_item({ tabedit = true })
        end, { buffer = cx.bufnr })
      end,
    })
  '';

  keymaps =
    [
      {
        mode = "n";
        action.__raw = "function() require('harpoon'):list():add() end";
        key = "<C-a>";
        options.desc = "Add file to harpoon";
        options.silent = true;
      }

      {
        mode = "n";
        action.__raw = "function() require('harpoon'):list():add() end";
        key = "<leader>ha";
        options.desc = "Add file to harpoon";
        options.silent = true;
      }
      {
        mode = "n";
        action.__raw = "function() require('harpoon'):list():clear() end";
        key = "<leader>hc";
        options.desc = "Clear all marks";
        options.silent = true;
      }
      {
        mode = "n";
        action.__raw = "function() require('harpoon').ui:toggle_quick_menu(require'harpoon':list()) end";
        key = "<leader>ht";
        options.desc = "Toggle harpoon menu";
        options.silent = true;
      }
      {
        mode = "n";
        action.__raw = "function() require('harpoon').ui:toggle_quick_menu(require'harpoon':list()) end";
        key = "<C-h>";
        options.desc = "Toggle harpoon menu";
        options.silent = true;
      }
      {
        mode = "n";
        action.__raw = "function() require('harpoon'):list():prev() end";
        key = "<C-b>";
        options.desc = "Go to previous harpoon file";
        options.silent = true;
      }

      {
        mode = "n";
        action.__raw = "function() require('harpoon'):list():next() end";
        key = "<C-n>";
        options.desc = "Go to next harpoon file";
        options.silent = true;
      }
    ]
    ++ lib.genList (n: {
      mode = "n";
      action.__raw = "function() require('harpoon'):list():select(${toString (n + 1)}) end";
      key = "<leader>h${toString (n + 1)}";
      options.desc = "Navigate to harpoon file ${toString (n + 1)}";
    }) harpoonFiles
    ++ lib.genList (n: {
      mode = "n";
      action.__raw = "function() require('harpoon'):list():replace_at(${toString (n + 1)}) end";
      key = "<leader>hr${toString (n + 1)}";
      options.desc = "Remove harpoon mark ${toString (n + 1)}";
    }) harpoonFiles
    ++ lib.genList (n: {
      mode = "n";
      action.__raw = "function() require('harpoon'):list():select(${toString (n + 1)}) end";
      key = "<C-${toString (n + 1)}>";
      options.desc = "Navigate to harpoon file ${toString (n + 1)}";
    }) harpoonFiles;
}

{
  autoCmd = [
    # Close filetypes with q
    {
      desc = "Close filetypes with q";
      event = "FileType";
      pattern = [
        "PlenaryTestPopup"
        "checkhealth"
        "dbout"
        "gitsigns-blame"
        "grug-far"
        "help"
        "lspinfo"
        "neotest-output"
        "neotest-output-panel"
        "neotest-summary"
        "notify"
        "qf"
        "spectre_panel"
        "startuptime"
        "tsplayground"
        "oil"
      ];
      callback.__raw = # Lua
        ''
          function(event)
               vim.bo[event.buf].buflisted = false
               vim.schedule(function()
                 vim.keymap.set("n", "q", function()
                   vim.cmd("close")
                   pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
                 end, {
                   buffer = event.buf,
                   silent = true,
                   desc = "Quit buffer",
                 })
               end)
             end
        '';
    }

    # Lint
    {
      desc = "Lint file";
      event = [ "BufWritePost" "InsertLeave" ];
      pattern = [ "*" ];
      callback.__raw = # Lua
        ''
          function()
            require("lint").try_lint()
          end
        '';
    }


    # Highlight on yank
    {
      desc = "Highlight on yank";
      event = "TextYankPost";
      pattern = [ "*" ];
      callback.__raw = # Lua
        ''
          function()
            (vim.hl or vim.highlight).on_yank()
          end
        '';
    }

    # Autoformat
    {
      desc = "Activate auto format";
      event = "FileType";
      pattern = [
        "nix"
        "lua"
      ];
      callback.__raw = # Lua
        ''
          function()
            vim.b.autoformat = true;
          end
        '';
    }

    # Remove trailing whitespace on save
    {
      event = "BufWrite";
      command = "%s/\\s\\+$//e";
    }

    # Set tabs to 4 on c#
    {
      desc = "";
      event = "FileType";
      pattern = [ "cs" "razor" ];
      command = "setlocal tabstop=4 shiftwidth=4";
    }


  ];
}

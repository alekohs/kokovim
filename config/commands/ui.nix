{
  autoCmd = [
    {
      event = "FileType";
      pattern = [ "snacks_layout_box" ];
      desc = "Set snacks.explorer to transparent";
      callback.__raw = # Lua
        ''
          function()
                local win_id = vim.fn.win_getid()
                local is_floating = vim.api.nvim_win_get_config(win_id).relative ~= ""
                local message = is_floating and "Floating window" or "Non-floating window"
                vim.notify("Snacks explorer: " .. "testing",  "debug", {
                  id = "Snacks opener",
                  title = "Snacks picker",
                })
          end
        '';
    }

  ];
}

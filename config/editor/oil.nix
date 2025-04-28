{
  plugins.oil = {
    enable = true;
  };

  keymaps = [
    {
      mode = "n";
      action = "<CMD>Oil --float<CR>";
      key = "<leader>o";
      options.desc = "Open oil";
      options.silent = true;
    }
  ];

  autoCmd = [
    {
      event = "FileType";
      desc = "Toggle hidden files";
      pattern = "oil";
      callback.__raw = ''
      function()
        local opts = { buffer = true }
        vim.keymap.set("n", "<S-h>", function() require("oil").toggle_hidden() end, opts)
      end
      '';
    }
  ];
}

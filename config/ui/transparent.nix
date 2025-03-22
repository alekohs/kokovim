{
  plugins.transparent = {
    enable = true;
    settings = {

      extra_groups = [
        "BufferLineTabClose"
        "BufferLineBufferSelected"
        "BufferLineFill"
        "BufferLineBackground"
        "BufferLineSeparator"
        "BufferLineIndicatorSelected"

        # "lualine"
        "Snacks"
      ];
    };
  };

  keymaps = [
    {
      mode = "n";
      action = "<CMD>TransparentToggle<CR>";
      key = "<leader>uo";
      options.desc = "Toggle transparent background";
    }
  ];

  extraConfigLua = # Lua
    ''
      require('transparent').clear_prefix('BufferLine')
      -- require('transparent').clear_prefix('lualine')
      require('transparent').clear_prefix('Snacks')
    '';

}

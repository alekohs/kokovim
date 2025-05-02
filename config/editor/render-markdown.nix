{ ... }:
{
  plugins.render-markdown = {
    enable = true;
    lazyLoad.settings.ft = "markdown";

    settings = {
      bullet = {
        icons = [
          "◆ "
          "• "
          "• "
        ];
        right_pad = 1;
      };
      code = {
        above = " ";
        below = " ";
        border = "thick";
        language_pad = 2;
        left_pad = 2;
        position = "right";
        right_pad = 2;
        sign = false;
        width = "block";
      };
      completions = {
        lsp = {
          enabled = true;
        };
        blink = {
          enabled = true;
        };
      };
      heading = {
        border = true;
        icons = [
          "󰲡 "
          "󰲣 "
          "󰲥 "
          "󰲧 "
          "󰲩 "
          "󰲫 "
        ];
        position = "inline";
        sign = false;
        width = "full";
      };
      render_modes = true;
      signs = {
        enabled = false;
      };
    };
  };

  autoCmd = [
    {
      event = "FileType";
       desc = "Toggle markdown render for buffer";
      pattern = "markdown";
      callback.__raw = ''
        function()
          local opts = { buffer = true, desc = "Toggle render-markdown for buffer" }
          vim.keymap.set("n", "<leader>mt", function() require("render-markdown").buf_toggle() end, opts)
        end
      '';
    }
  ];

}

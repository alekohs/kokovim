{
  plugins.kulala = {
    enable = true;
    lazyLoad.settings.event = "DeferredUIEnter";
    lazyLoad.settings.ft = [
      "http"
      "rest"
    ];

    settings = {
      ui.display_mode = "float";
    };
  };

  plugins.which-key.settings.spec = [
    {
      __unkeyed = "<leader>R";
      group = "Kulala";
      icon = " ";
    }
  ];

  keymaps = [
    {
      mode = "n";
      key = "<leader>Ro";
      action.__raw = "function() require('kulala').open() end";
      options = {
        desc = "Open kulala";
      };
    }
    {
      mode = "n";
      key = "<leader>Rb";
      action.__raw = "function() require('kulala').scratchpad() end";
      options = {
        desc = "Open scratchpad";
      };
    }

    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>Rs";
      action.__raw = "function() require('kulala').run() end";
      options = {
        desc = "Send request";
      };
    }
    {
      mode = [ "n" ];
      key = "<leader>Rr";
      action.__raw = "function() require('kulala').replay() end";
      options = {
        desc = "Replay request";
      };
    }

    {
      mode = "n";
      key = "<leader>RS";
      action.__raw = "function() require('kulala').show_stats() end";
      options = {
        desc = "Show stats";
      };
    }
  ];
}

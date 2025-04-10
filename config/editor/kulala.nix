{
  plugins.kulala = {
    enable = true;
    lazyLoad.settings.event = "DeferredUIEnter";
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
      mode = [ "n" "v" ];
      key = "<leader>Rs";
      action.__raw = "function() require('kulala').run() end";
      options = {
        desc = "Open kulala";
      };
    }

  ];
}

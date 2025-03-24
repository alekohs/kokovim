{
  plugins.todo-comments = {
    enable = true;
    lazyLoad.settings = {
      cmd = [
        "TodoTrouble"
        "TodoTelescope"
      ];
      event = "DeferredUIEnter";
    };
  };

  keymaps = [
    # {
    #   key = "[t";
    #   action.__raw = # Lua
    #     ''
    #       require("todo-comments").jump_next()
    #     '';
    #   options = {
    #     desc = "Next todo comment";
    #   };
    # }
    # {
    #   key = "]t";
    #   action.__raw = # Lua
    #     ''
    #       require("todo-comments").jump_prev()
    #     '';
    #   options = {
    #     desc = "Previous todo comment";
    #   };
    # }

    {
      mode = "n";
      key = "<leader>st";
      action = "<CMD>TodoTelescope<CR>";
      options = {
        desc = "Todo";
      };
    }
  ];
}

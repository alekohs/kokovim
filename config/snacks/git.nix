{
  plugins.snacks.settings = {
    gitbrowse.enabled = true;
    lazygit.enabled = true;
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>go";
      action = "<CMD>lua Snacks.gitbrowse()<CR>";
      options.desc = "Open file in browser";
    }
    {
      mode = "n";
      key = "<leader>gg";
      action = "<CMD>lua Snacks.lazygit()<CR>";
      options.desc = "Open lazygit";
    }

    {
      mode = "n";
      key = "<leader>gs";
      action = ''<CMD>lua Snacks.picker.git_status()<CR>'';
      options = {
        desc = "Find git status";
      };
    }
  ];
}

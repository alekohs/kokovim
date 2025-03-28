{
  plugins.neogen = {
    enable = true;
    snippetEngine = "mini";
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>cn";
      action = "<CMD>Neogen<CR>";
      options = {
        desc = "Generate Annotation";
      };
    }
  ];
}

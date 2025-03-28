{
  plugins.neogen = {
    enable = true;
    snippetEngine = "mini";
    languages = {
      cs = {
        template = {
          annotation_convention = "xmldoc";
        };
      };
    };
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

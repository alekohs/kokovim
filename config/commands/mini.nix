{
  autoCmd = [
    {
      event = "FileType";
      desc = "Disable animation in grug";
      pattern = "grug-far";
      callback.__raw = ''
        function()
          vim.b.minianimate_disable = true
        end
      '';
    }
  ];
}

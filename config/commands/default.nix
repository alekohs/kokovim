{
  imports = [
    ./editor.nix
    ./lsp.nix
  ];

  autoCmd = [
    {
      event = "FileType";
      pattern = [
        "tex"
        "latex"
        "markdown"
      ];
      command = "setlocal spell spelllang=en_us";
    }

  ];
}

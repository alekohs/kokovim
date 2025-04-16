{
  imports = [
    ./dotnet.nix
    ./editor.nix
    ./lsp.nix
    ./mini.nix
    ./ui.nix
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

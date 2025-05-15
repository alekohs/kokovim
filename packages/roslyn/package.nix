{
  pkgs,
  vimUtils,
}:
vimUtils.buildVimPlugin {
  pname = "roslyn-nvim";
  version = "0.1";

  src = pkgs.fetchFromGitHub {
    owner = "seblyng";
    repo = "roslyn.nvim";
    rev = "main";
    hash = "sha256-0d298e68efa511df18a0bd4fd9a0c9bf70ebdbf2";
  };

  dependencies = [ pkgs.roslyn-ls ];
}

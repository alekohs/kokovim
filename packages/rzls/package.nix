{
  pkgs,
  vimUtils,
}:
vimUtils.buildVimPlugin {
  pname = "rzls";
  version = "0.1";

  src = pkgs.fetchFromGitHub {
    owner = "tris203";
    repo = "rzls.nvim";
    rev = "main";
  };

  dependencies = [ pkgs.roslyn-ls pkgs.rzls ];
}

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
    hash = "sha256-ebb652a4876c3c6af344333a6fc6bacffd85a27a";
  };

  dependencies = [ pkgs.roslyn-ls pkgs.rzls ];
}

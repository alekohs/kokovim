{
  pkgs,
  vimUtils,
}:
vimUtils.buildVimPlugin {
  pname = "easy-dotnet-nvim";
  version = "0.1";

  src = pkgs.fetchFromGitHub {
    owner = "GustavEikaas";
    repo = "easy-dotnet.nvim";
    rev = "main";
  };


  dependencies = [ pkgs.jq ];
  meta.homepage = "https://github.com/GustavEikaas/easy-dotnet.nvim/";
}

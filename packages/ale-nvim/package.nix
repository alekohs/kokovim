{
  pkgs,
  vimUtils,
}:
vimUtils.buildVimPlugin {
  pname = "ale-nvim";
  version = "2025-03-20";
  src = pkgs.fetchFromGitHub {
    owner = "dense-analysis";
    repo = "ale";
    rev = "neovim-lsp-api"; # TODO: This is a fix to integrate it with neovim better. Change this to master after it has been merged
    sha256 = "SOMa0Dl/OPnVIoC9raOEtxcdftyMAn8Xvv7bB4KTn9k=";
  };
  meta.homepage = "https://github.com/dense-analysis/ale/";
}

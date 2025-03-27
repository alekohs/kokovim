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
    rev = "master";
    sha256 = "SOMa0Dl/OPnVIoC9raOEtxcdftyMAn8Xvv7bB4KTn9k=";
  };

  meta.homepage = "https://github.com/dense-analysis/ale/";
}

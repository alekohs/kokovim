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
    sha256 = "ZfZ+tFfMAxkLr+WUaCq0O3VmCyfKo40AN5HXbXR3MEk=";
  };

  meta.homepage = "https://github.com/dense-analysis/ale/";
}

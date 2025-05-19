{
  pkgs,
  vimUtils,
}:
vimUtils.buildVimPlugin {
  pname = "colorful-menu-nvim";
  version = "2025-03-01";
  src = pkgs.fetchFromGitHub {
    version = " 0.1";
    owner = "xzbdmw";
    repo = "colorful-menu.nvim";
    rev = "0041037582353a2101f0ba8bd8cae21c064921dc";
    sha256 = "NJQGmM0ZjRA/IumbCKJVvDeAfJ/mext4uYRdIgcEaqE=";
  };
  meta.homepage = "https://github.com/xzbdmw/colorful-menu.nvim/";

  dependencies = [ pkgs.vimPlugins.blink-cmp ];

  nvimSkipModule = [
    "repro_blink"
    "repro_cmp"
  ];
}

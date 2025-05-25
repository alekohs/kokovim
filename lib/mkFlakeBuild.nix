{
  pkgs,
  ...
}:
{
  mkVimPlugin =
    {
      src,
      pname,
      nvimSkipModule ? [],
    }:
    pkgs.vimUtils.buildVimPlugin {
      inherit pname src nvimSkipModule;
      version = src.lastModifiedDate;
    };

  mkPythonPackage =
    {
      src,
      pname,
      propagatedBuildInputs ? [ ]
    }:

    pkgs.python3Packages.buildPythonApplication {
      inherit pname src propagatedBuildInputs;
      version = src.lastModifiedDate;
    };
}

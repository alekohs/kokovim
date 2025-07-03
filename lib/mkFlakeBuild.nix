{
  pkgs,
  ...
}:
{
  mkVimPlugin =
    {
      src,
      pname,
      nvimSkipModule ? [ ],
    }:
    pkgs.vimUtils.buildVimPlugin {
      inherit pname src nvimSkipModule;
      version = src.lastModifiedDate;
    };

  mkPythonPackage =
    {
      src,
      pname,
      # format ? "",
      pyproject ? false,
      propagatedBuildInputs ? [ ],
      nativeBuildInputs ? [ ],
    }:

    pkgs.python3Packages.buildPythonApplication {
      inherit
        pname
        src
        pyproject
        propagatedBuildInputs
        nativeBuildInputs
        ;
      version = src.lastModifiedDate;
    };
}

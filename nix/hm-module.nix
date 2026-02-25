{ self }:
{ config, lib, pkgs, ... }:
let
  cfg = config.programs.kokovim;
  pkg =
    if cfg.roslyn.enable
    then self.packages.${pkgs.system}.kokovim-roslyn
    else self.packages.${pkgs.system}.kokovim;
in
{
  options.programs.kokovim = {
    enable = lib.mkEnableOption "kokovim";
    roslyn.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable roslyn/rzls/netcoredbg. Disable to avoid building dotnet on Darwin.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkg ];
  };
}

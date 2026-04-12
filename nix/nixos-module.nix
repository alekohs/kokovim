{ self }:
{ config, lib, pkgs, ... }:
let
  cfg = config.programs.kokovim;
  pkg =
    if cfg.unstable.enable then self.packages.${pkgs.system}.kokovim-unstable
    else if cfg.roslyn.enable then self.packages.${pkgs.system}.kokovim
    else self.packages.${pkgs.system}.kokovim-no-roslyn;
in
{
  options.programs.kokovim = {
    enable = lib.mkEnableOption "kokovim";
    roslyn.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable roslyn/rzls/netcoredbg. Disable to avoid building dotnet on Darwin.";
    };
    unstable.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use packages from nixpkgs-unstable instead of stable.";
    };
    biome.globalConfig = lib.mkOption {
      type = lib.types.nullOr (lib.types.attrsOf lib.types.anything);
      default = null;
      description = ''
        Global biome configuration. When set, users should manage their own
        ~/.config/biome.json (e.g. via home-manager's programs.kokovim.biome.globalConfig).
        This option is informational only at the system level.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkg ];
  };
}

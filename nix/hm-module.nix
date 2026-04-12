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
        Global biome configuration written to ~/.config/biome.json.
        Used by biome as a fallback when no project-level biome.json is found.
        If null, no global config is managed (biome will error if no project config exists).
      '';
      example = {
        linter.enabled = true;
        linter.rules.recommended = true;
        formatter.enabled = true;
        formatter.indentStyle = "space";
        formatter.indentWidth = 2;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkg ];
    home.file.".config/biome.json" = lib.mkIf (cfg.biome.globalConfig != null) {
      text = builtins.toJSON cfg.biome.globalConfig;
    };
  };
}

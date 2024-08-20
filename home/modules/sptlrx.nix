{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkPackageOption
    mkOption
    mkIf
    ;
  cfg = config.programs.sptlrx;
  yamlFormat = pkgs.formats.yaml {};
in {
  meta.maintainers = with lib.maintainers; [_71zenith];
  options.programs.sptlrx = {
    enable = mkEnableOption "sptlrx";

    package = mkPackageOption pkgs "sptlrx" {};

    settings = mkOption {
      inherit (yamlFormat) type;
      default = {};
    };
  };
  config = mkIf cfg.enable {
    home.packages = [cfg.package];

    xdg.configFile = {
      "sptlrx/config.yaml" = mkIf (cfg.settings != {}) {
        source = yamlFormat.generate "sptlrx-app" cfg.settings;
      };
    };
  };
}

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
  cfg = config.programs.satty;
  tomlFormat = pkgs.formats.toml {};
in {
  meta.maintainers = with lib.hm.maintainers; [_71zenith];
  options.programs.satty = {
    enable = mkEnableOption "satty";

    package = mkPackageOption pkgs "satty" {};

    settings = mkOption {
      inherit (tomlFormat) type;
      default = {};
    };
  };
  config = mkIf cfg.enable {
    home.packages = [cfg.package];

    xdg.configFile = {
      "satty/config.toml" = mkIf (cfg.settings != {}) {
        source = tomlFormat.generate "satty-app" cfg.settings;
      };
    };
  };
}

{
  config,
  lib,
  pkgs,
  prog ? "",
  type ? "",
  ...
}: let
  inherit (lib) mkEnableOption mkPackageOption mkOption mkIf;
  cfg = config.programs.${prog};
  format = pkgs.formats.${type} {};
in {
  meta.maintainers = with lib.maintainers; [_71zenith];
  options.programs.${prog} = {
    enable = mkEnableOption prog;

    package = mkPackageOption pkgs prog {};

    settings = mkOption {
      inherit (format) type;
      default = {};
    };
  };
  config = mkIf cfg.enable {
    home.packages = [cfg.package];

    xdg.configFile = {
      "${prog}/config.${type}" = mkIf (cfg.settings != {}) {
        source = format.generate "${prog}-app" cfg.settings;
      };
    };
  };
}

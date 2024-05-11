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
  cfg = config.programs.neovide;
  tomlFormat = pkgs.formats.toml {};
in {
  meta.maintainers = with lib.hm.maintainers; [zen];
  options.programs.neovide = {
    enable = mkEnableOption "neovide";

    package = mkPackageOption pkgs "neovide" {};

    settings = mkOption {
      inherit (tomlFormat) type;
      default = {};
    };
  };
  config = mkIf cfg.enable {
    home.packages = [cfg.package];

    xdg.configFile = {
      "neovide/config.toml" = mkIf (cfg.settings != {}) {
        source = tomlFormat.generate "neovide-app" cfg.settings;
      };
    };
  };
}

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
    types
    mkIf
    getExe
    ;
  cfg = config.programs.spotify-player;
  tomlFormat = pkgs.formats.toml {};
in {
  meta.maintainers = with lib.hm.maintainers; [zen];
  options.programs.spotify-player = {
    enable = mkEnableOption "spotify-player";

    package = mkPackageOption pkgs "spotify-player" {};

    settings = mkOption {
      type = tomlFormat.type;
      default = {};
    };
    enableZshIntegration = mkOption {
      default = true;
      type = types.bool;
    };
    themes = mkOption {
      type = types.listOf tomlFormat.type;
      default = [];
    };
    keymaps = mkOption {
      type = types.listOf tomlFormat.type;
      default = [];
    };
  };
  config = mkIf cfg.enable {
    home.packages = [cfg.package];

    programs.zsh.initExtra = mkIf cfg.enableZshIntegration ''
      eval "$(${getExe cfg.package} generate zsh)"
    '';

    xdg.configFile = {
      "spotify-player/app.toml" = mkIf (cfg.settings != {}) {
        source = tomlFormat.generate "spotify-player-app" cfg.settings;
      };
      "spotify-player/theme.toml" = mkIf (cfg.themes != []) {
        source = tomlFormat.generate "spotify-player-theme" {inherit (cfg) themes;};
      };
      "spotify-player/keymap.toml" = mkIf (cfg.keymaps != []) {
        source = tomlFormat.generate "spotify-player-keymap" {
          inherit (cfg) keymaps;
        };
      };
    };
  };
}

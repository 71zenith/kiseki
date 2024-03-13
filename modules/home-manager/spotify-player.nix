{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.spotify-player;
  tomlFormat = pkgs.formats.toml {};
in {
  options.programs.spotify-player = {
    enable = mkEnableOption "spotify-player";

    package = mkOption {
      type = types.package;
      default = pkgs.spotify-player;
      defaultText = literalExpression "pkgs.spotify-player";
      description = "The package to use for spotify-player.";
    };

    settings = mkOption {
      type = tomlFormat.type;
      default = {};
    };
    keymaps = mkOption {
      type = tomlFormat.type;
      default = {};
    };
  };
  config = mkIf cfg.enable {
    xdg.configFile = let
      settings = {
        "spotify-player/app.toml" = mkIf (cfg.settings != {}) {
          source = tomlFormat.generate "spotify-player-config" cfg.settings;
        };
        "spotify-player/keymap.toml" = mkIf (cfg.keymaps != {}) {
          source =
            tomlFormat.generate "spotify-player-keymaps-config" cfg.keymaps;
        };
      };
    in
      settings;
  };
}

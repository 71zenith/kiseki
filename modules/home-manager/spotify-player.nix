{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.programs.spotify-player;
  tomlFormat = pkgs.formats.toml { };
in
{
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
      default = { };
      example = literalExpression ''
        {
          theme = "default";
          playback_window_position = "Bottom";
          device = {
            name = "spotify-player";
            device_type = "speaker";
            volume = 70;
            bitrate = 32;
          };
        }
      '';
    };
    keymaps = mkOption {
      type = tomlFormat.type;
      default = { };
      example = literalExpression ''
        {
          keymaps = [
          {
            command = "PreviousPage";
            key_sequence = "esc";
          }
          {
            command = "ClosePopup";
            key_sequence = "q";
          }
          ];
        }
      '';
    };
    theme = mkOption {
      type = tomlFormat.type;
      default = { };
      example = literalExpression ''
        {
          "ui.menu" = transparent;
          "ui.menu.selected" = { modifiers = [ "reversed" ]; };
          "ui.linenr" = { fg = gray; bg = dark-gray; };
          "ui.popup" = { modifiers = [ "reversed" ]; };
          "ui.linenr.selected" = { fg = white; bg = black; modifiers = [ "bold" ]; };
          "ui.selection" = { fg = black; bg = blue; };
          "ui.selection.primary" = { modifiers = [ "reversed" ]; };
          "comment" = { fg = gray; };
          "ui.statusline" = { fg = white; bg = dark-gray; };
        }
      '';
    };
  };
  config = mkIf cfg.enable {
    xdg.configFile = let 
      settings = 
      {
      "spotify-player/app.toml" = mkIf (cfg.settings != { }) {
        source = tomlFormat.generate "spotify-player-config" cfg.settings;
      };
      "spotify-player/keymap.toml" = mkIf (cfg.keymaps != { }) {
        source = tomlFormat.generate "spotify-player-keymaps-config" cfg.keymaps;
      };
      "spotify-player/theme.toml" = mkIf (cfg.theme != { }) {
        source = tomlFormat.generate "spotify-player-theme-config" cfg.theme;
      };
    };
  in 
    settings;
  };
}

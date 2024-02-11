{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.programs.spotify-player;
  tomlFormat = pkgs.formats.toml { };
in
{
  meta.maintainers = [ maintainers.zen ];

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
          device = {
            name = "spotify-player";
            device_type = "speaker";
            volume = 70;
            bitrate = 32;
          };
        }
      '';
      description = ''
        Configuration written to
        {file}`$XDG_CONFIG_HOME/spotify-player/app.toml`.

        See <https://github.com/aome510/spotify-player/blob/master/examples/app.toml>
        for the full list of options.
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
          };
          {
            command = "SeekForward";
            key_sequence = "L";
          };
          ];
        }
      '';
      description = ''
        Keybinding specific configuration at
        {file}`$XDG_CONFIG_HOME/spotify-player/keymap.toml`.

        See <https://github.com/aome510/spotify-player/blob/master/examples/keymap.toml>
        for more information.
      '';
    };
    theme = mkOption {
      type = tomlFormat.type;
      default = { };
      example = literalExpression ''
        {
          base16 = let
            gray = "#665c54";
            dark-gray = "#3c3836";
            white = "#fbf1c7";
            black = "#282828";
            red = "#fb4934";
            green = "#b8bb26";
            yellow = "#fabd2f";
            orange = "#fe8019";
            blue = "#83a598";
            magenta = "#d3869b";
            cyan = "#8ec07c";
          in {
            "ui.menu" = transparent;
            "ui.menu.selected" = { modifiers = [ "reversed" ]; };
            "ui.linenr" = { fg = gray; bg = dark-gray; };
            "ui.popup" = { modifiers = [ "reversed" ]; };
            "ui.linenr.selected" = { fg = white; bg = black; modifiers = [ "bold" ]; };
            "ui.selection" = { fg = black; bg = blue; };
            "ui.selection.primary" = { modifiers = [ "reversed" ]; };
            "comment" = { fg = gray; };
            "ui.statusline" = { fg = white; bg = dark-gray; };
          };
        }
      '';
      description = ''
        Each theme is written to
        {file}`$XDG_CONFIG_HOME/spotify-player/theme.toml`.
        Where the name of each attribute is the theme-name ().

        See <https://github.com/aome510/spotify-player/blob/master/examples/theme.toml>
        for the full list of options.
      '';
    };

    config = mkIf cfg.enable {
      home.packages = [ cfg.package ];
      xdg.configFile = {
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
    };
  };
}

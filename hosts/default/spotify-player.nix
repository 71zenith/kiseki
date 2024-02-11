{ config, pkgs, lib, ... }:
let
  inherit (config.colorScheme) palette;
in
{
  imports = [
    ../../modules/home-manager/spotify-player.nix
  ];

  programs.spotify-player = {
    enable = true;
    settings = {
      client_id = "1bc0214aae08496bb50af4cd51aa2c94";
      client_port = 8080;
      tracks_playback_limit = 5;
      track_table_item_max_len = 32;
      play_icon = " ";
      pause_icon = " ";
      enable_media_control = true;
      default_device = "ur-mom";
      theme = "oxocarbon";
      playback_window_position = "Bottom";
      border_type = "Hidden";
      progress_bar_type = "Rectangle";
      cover_img_scale = 2.2;
    };
    keymaps = {
      keymaps = [
        {
          command = "PreviousPage";
          key_sequence = "esc";
        }
        {
          command = "ClosePopup";
          key_sequence = "q";
        }
        {
          command = "Repeat";
          key_sequence = "R";
        }
        {
          command = "Shuffle";
          key_sequence = "S";
        }
        {
          command = "Quit";
          key_sequence = "C-c";
        }
        {
          command = "SeekForward";
          key_sequence = "L";
        }
        {
          command = "SeekBackward";
          key_sequence = "H";
        }
        {
          command = "PageSelectNextOrScrollDown";
          key_sequence = "C-d";
        }
        {
          command = "LikedTrackPage";
          key_sequence = "g o";
        }
      ];
    };
    theme = {
      themes = [
        {
          name = "oxocarbon";
          palette = {
            background = "#${palette.base00}";
            foreground = "#${palette.base06}";
            black = "#${palette.base00}";
            red = "#${palette.base0A}";
            green = "#${palette.base03}";
            yellow = "#${palette.base00}";
            blue = "#${palette.base0B}";
            magenta = "#${palette.base0E}";
            cyan = "#${palette.base08}";
            white = "#${palette.base04}";
            bright_black = "#${palette.base01}";
            bright_red = "#${palette.base0C}";
            bright_green = "#${palette.base0D}";
            bright_yellow = "#${palette.base00}";
            bright_blue = "#${palette.base0F}";
            bright_magenta = "#${palette.base07}";
            bright_cyan = "#${palette.base08}";
            bright_white = "#${palette.base06}";
          };
        }
      ];
    };
  };
}

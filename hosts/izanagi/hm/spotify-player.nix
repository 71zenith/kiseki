{
  config,
  pkgs,
  ...
}: let
  spotify-player = pkgs.callPackage ../../../pkgs/spotify-player.nix {};
  inherit (config.stylix.base16Scheme) palette slug;
in {
  disabledModules = ["programs/spotify-player.nix"];
  imports = [
    ../../../modules/hm/spotify-player.nix
  ];

  programs.spotify-player = {
    enable = true;
    package = spotify-player;
    enableZshIntegration = true;
    settings = {
      client_id = "1bc0214aae08496bb50af4cd51aa2c94";
      client_port = 8080;
      tracks_playback_limit = 5;
      track_table_item_max_len = 32;
      play_icon = " ";
      pause_icon = " ";
      enable_media_control = true;
      default_device = "ur-mom";
      theme = "${slug}";
      playback_window_position = "Bottom";
      liked_icon = " ";
      border_type = "Hidden";
      progress_bar_type = "Rectangle";
      cover_img_scale = 1.7;
      device = {
        name = "ur mom";
        device_type = "speaker";
        bitrate = 320;
        audio_cache = false;
      };
    };
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
        command = "VolumeUp";
        key_sequence = "=";
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
        command = "PageSelectPreviousOrScrollUp";
        key_sequence = "C-u";
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
    themes = [
      {
        name = "${slug}";
        palette = with palette; {
          black = "#${base00}";
          foreground = "#${base03}";
          bright_black = "#${base01}";
          yellow = "#${base02}";
          green = "#${base03}";
          bright_yellow = "#${base04}";
          white = "#${base05}";
          bright_white = "#${base06}";
          cyan = "#${base07}";
          bright_cyan = "#${base08}";
          blue = "#${base09}";
          bright_red = "#${base0A}";
          bright_blue = "#${base0B}";
          red = "#${base0C}";
          bright_green = "#${base0D}";
          magenta = "#${base07}";
          bright_magenta = "#${base0F}";
        };
        component_style = {
          block_title = {
            fg = "BrightGreen";
            modifiers = ["Italic" "Bold"];
          };
          playback_track = {
            fg = "BrightMagenta";
            modifiers = ["Italic"];
          };
          playback_album = {
            fg = "BrightRed";
            modifiers = ["Italic"];
          };
          playback_artists = {
            fg = "BrightCyan";
            modifiers = [];
          };
          playback_metadata = {
            fg = "BrightBlue";
            modifiers = [];
          };
          playback_progress_bar = {
            fg = "BrightGreen";
            modifiers = ["Italic"];
          };
          current_playing = {
            fg = "Red";
            modifiers = ["Bold" "Italic"];
          };
          page_desc = {
            fg = "Magenta";
            modifiers = ["Bold" "Italic"];
          };
          table_header = {
            fg = "Blue";
            modifiers = ["Bold"];
          };
          border = {fg = "BrightYellow";};
          selection = {
            fg = "Red";
            modifiers = ["Bold" "Reversed"];
          };
        };
      }
    ];
  };
}

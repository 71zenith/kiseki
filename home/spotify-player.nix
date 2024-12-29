{
  inputs,
  config,
  pkgs,
  ...
}: {
  imports = [inputs.sops-nix.homeManagerModules.sops];
  sops = {
    defaultSopsFile = ../secrets/secrets.yaml;
    age.sshKeyPaths = ["${config.home.homeDirectory}/.ssh/id_ed25519"];
    secrets = {
      spot_username = {};
      spot_auth_data = {};
      spot_client_id = {};
    };
    templates."credentials.json" = {
      content = builtins.toJSON {
        username = config.sops.placeholder.spot_username;
        auth_type = 1;
        auth_data = config.sops.placeholder.spot_auth_data;
      };
      path = "${config.xdg.cacheHome}/spotify-player/credentials.json";
    };
  };
  systemd.user.services.changeCover = {
    Unit = {
      PartOf = ["graphical-session.target"];
      After = ["graphical-session-pre.target"];
    };
    Service = {
      ExecStart = pkgs.writeShellScript "changeCover" ''
        playerctl metadata --format '{{playerName}} {{mpris:artUrl}}' -F  --ignore-player firefox | while read -r player url; do
          if [ "$player" = "spotify_player" ] && [ -n "$url" ]; then
            curl "$url" > /tmp/cover.jpg
            pkill -RTMIN+8 waybar
            magick /tmp/cover.jpg -resize 1x1\! -format "fg = #%[hex:u]\n" info: 2>/dev/null > /tmp/cover.info
          fi
        done
      '';
      Restart = "always";
      RestartSec = "5s";
    };
    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };
  programs.spotify-player = {
    enable = true;
    settings = {
      client_id_command = "cat /run/secrets/spot_client_id";
      client_port = 8080;
      play_icon = " ";
      pause_icon = " ";
      enable_media_control = true;
      default_device = "ur-mom";
      theme = config.stylix.base16Scheme.slug;
      seek_duration_secs = 10;
      liked_icon = "󰋑 ";
      border_type = "Hidden";
      progress_bar_type = "Rectangle";
      cover_img_scale = 1.9;
      cover_img_length = 10;
      layout = {
        playback_window_position = "Bottom";
      };
      device = {
        name = "lain";
        device_type = "speaker";
        bitrate = 320;
        audio_cache = false;
        autoplay = true;
      };
    };
    actions = [
      {
        action = "ToggleLiked";
        key_sequence = "C-l";
      }
      {
        action = "AddToLibrary";
        key_sequence = "C-a";
      }
      {
        action = "Follow";
        key_sequence = "C-f";
      }
    ];
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
        name = config.stylix.base16Scheme.slug;
        palette = with config.lib.stylix.colors.withHashtag; {
          black = base00;
          foreground = base03;
          bright_black = base01;
          yellow = base02;
          green = base03;
          bright_yellow = base04;
          white = base05;
          bright_white = base06;
          cyan = base07;
          bright_cyan = base08;
          blue = base09;
          bright_red = base0A;
          bright_blue = base0B;
          red = base0C;
          bright_green = base0D;
          magenta = base07;
          bright_magenta = base0F;
        };
        component_style = {
          block_title = {
            fg = "BrightGreen";
            modifiers = ["Italic" "Bold"];
          };
          like = {
            fg = "Red";
            modifiers = ["Bold"];
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
          playlist_desc = {
            fg = "White";
            modifiers = ["Italic"];
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
          secondary_row = {bg = "BrightBlack";};
        };
      }
    ];
  };
}

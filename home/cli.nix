{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    (import ./modules.nix {
      inherit config lib pkgs;
      prog = "sptlrx";
      type = "yaml";
    })
  ];
  programs = {
    btop = {
      enable = true;
      settings = {
        theme_background = false;
        vim_keys = true;
        rounded_corners = false;
      };
    };

    less = {
      enable = true;
      keys = ''
        h left-scroll
        l right-scroll
      '';
    };

    direnv = {
      enable = true;
      silent = true;
      nix-direnv.enable = true;
    };

    zoxide = {
      enable = true;
      enableFishIntegration = true;
      options = ["--cmd cd"];
    };

    ripgrep = {
      enable = true;
      arguments = [
        "--ignore-file=${pkgs.writeText ".ignore" ''
          flake.lock
        ''}"
        "-i"
      ];
    };

    fd = {
      enable = true;
      extraOptions = ["-p" "-i"];
    };

    bat.enable = true;

    eza = {
      enable = true;
      enableFishIntegration = true;
      git = true;
      icons = "always";
      extraOptions = ["--hyperlink" "--no-quotes"];
    };

    sptlrx = {
      enable = true;
      settings = {
        player = "mpris";
        host = "lyricsapi.vercel.app";
        ignoreErrors = true;
        timerInterval = 200;
        updateInterval = 2000;
        style = with config.lib.stylix.colors.withHashtag; {
          hAlignment = "center";
          before = {
            foreground = base03;
            bold = false;
            faint = true;
          };
          current = {
            foreground = base0B;
            bold = true;
            italic = true;
          };
          after.foreground = base03;
        };
        mpris.players = ["spotify_player" "mpv"];
      };
    };

    fzf = {
      enable = true;
      enableFishIntegration = true;
      fileWidgetCommand = "fd -E .direnv -t f";
      colors.bg = lib.mkForce "-1";
    };

    yazi = {
      enable = true;
      enableFishIntegration = true;
      shellWrapperName = "ya";
      keymap = {
        manager.prepend_keymap = [
          {
            run = ''shell 'for path in "$@"; do echo "file://$path"; done | wl-copy -t text/uri-list' --confirm'';
            on = ["c" "f"];
          }
          {
            run = ''shell "$SHELL" --block --confirm'';
            on = ["w"];
          }
        ];
      };
      settings = {
        manager = {
          ratio = [1 3 3];
          sort_by = "natural";
          show_hidden = true;
        };
      };
      theme = {
        status.separator_open = "";
        status.separator_close = "";
      };
    };
  };
}

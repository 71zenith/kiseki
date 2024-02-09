{ config, inputs, stylix, pkgs, ... }:
{
  programs.btop = {
    enable = true;
    settings = {
      color_theme = "tomorrow-night";
      theme_background = false;
      vim_keys = true;
    };
  };

  programs.zathura = {
    enable = true;
    options = {
      render-loading = "false";
      font = "Noto Sans 14";
    };
    mappings = {
      i = "recolor";
      f = "toggle_fullscreen";
    };
  };

  programs.mpv = {
    enable = true;
    config = {
      osc = "no";
      osd-bar = "no";
      profile = "gpu-hq";
      vo = "gpu";
      scale = "ewa_lanczossharp";
      cscale = "ewa_lanczossharp";
      save-position-on-quit = "yes";
      video-sync = "display-resample";
      interpolation = "yes";
      tscale = "oversample";
 
      image-display-duration = "inf";
      osd-font = "Monaspace Radon";
 
      cache = "yes";
      demuxer-max-bytes = "1000MiB";
      demuxer-max-back-bytes = "50MiB";
      demuxer-readahead-secs = "60";
      border = "no";
      keepaspect-window = "no";
    };
    bindings = {
      "l" = "seek 5";
      "h" = "seek -5";
      "k" = "seek 60";
      "j" = "seek -60";
      "shift+s" = "script-binding crop-screenshot";
    };
    scripts = [ pkgs.mpvScripts.mpris pkgs.mpvScripts.uosc];
  };

  programs.bat = {
    enable = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.git = {
    enable = true;
    userName = "zen";
    userEmail = "71zenith@proton.me";
  };
  
  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "Monaspace Radon:size=14";
	pad = "10x10";
      };
      mouse = {
        hide-when-typing = "no";
      };
      key-bindings = {
        scrollback-up-page = "Control+u";
        scrollback-down-page = "Control+d";
        scrollback-up-line = "Mod1+k";
        scrollback-down-line = "Mod1+j";
      };
      cursor = {
        style = "beam";
	color = "282a36 f8f8f2";
      };
      colors = {
        alpha = 0.85;
	foreground = "ffffff";
	background = "161616";
        regular0 = "262626";
 	regular1 = "ff7eb6";
 	regular2 = "42be65";
 	regular3 = "ffe97b";
 	regular4 = "33b1ff";
 	regular5 = "ee5396";
 	regular6 = "3ddbd9";
 	regular7 = "dde1e6";
 
 	bright0 = "393939";
 	bright1 = "ff7eb6";
 	bright2 = "42be65";
 	bright3 = "ffe97b";
 	bright4 = "33b1ff";
 	bright5 = "ee5396";
 	bright6 = "3ddbd9";
 	bright7 = "ffffff";
      };
    };
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    syntaxHighlighting = {
      enable = true;
    };
    historySubstringSearch = {
      enable = true;
    };
    autocd = true;
    defaultKeymap = "viins";
  };


  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    plugins = with pkgs; [
      rofi-top
      rofi-emoji
      rofi-calc
      rofi-file-browser
    ];
    extraConfig = {
      modi = "drun,run";
      sidebar-mode = true;
      show-icons = true;
      icon-theme = "Nordzy";
    };
  };
  services.mako = {
    enable = true;
    defaultTimeout = 5000;
    font = "Monaspace Radon 13";
    borderSize = 0;
    width = 330;
    height = 200;
  };

  programs.eza = {
    enable = true;
    enableAliases = true;
    git = true;
    icons = true;
  };
}

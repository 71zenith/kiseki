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
    };
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    initExtra = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme; [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh" ;
    syntaxHighlighting = {
      enable = true;
    };
    historySubstringSearch = {
      enable = true;
    };
    history.size = 10000000;
    shellAliases = {
      up = "sudo nixos-rebuild switch --flake ~/nix#default";
      del = "sudo nix-collect-garbage --delete-old";
      pm = "pulsemixer";
      rm = "rm -Ivr";
      mv = "mv -iv";
      cp = "cp -ivr";
      c = "clear";
      df = "duf";
      du = "dust";
      cd = "z";
      f = "free -h";
      ko = "pkill";
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
    borderSize = 3;
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

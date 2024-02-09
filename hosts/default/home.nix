{ config, pkgs, ... }:

{
  home.username = "zen";
  home.homeDirectory = "/home/zen";

  home.stateVersion = "24.05";
  home.packages = [

  ];

  home.pointerCursor = {
    name = "phinger-cursors-light";
    package = pkgs.phinger-cursors;
    size = 32;
    x11.enable = true;
    gtk.enable = true;
  };

  gtk = {
    enable = true;
    iconTheme = {
      name = "Zafiro-icons-Dark";
      package = pkgs.zafiro-icons;
    };
    theme = {
      package = pkgs.flat-remix-gtk;
      name = "Flat-Remix-GTK-Grey-Darkest";
    };
  };

  qt = {
    enable = true;
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


  programs.eza = {
    enable = true;
    enableAliases = true;
    git = true;
    icons = true;
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

  wayland.windowManager.hyprland = {
    enable = true;
    settings = { 
    "$mod1" = "ALT";
    "$mod2" = "ALTSHIFT";
    "$mod3" = "ALTCONTROL";
    "$screenshotarea" = "hyprctl keyword animation 'fadeOut,0,0,default'; grimblast --notify copy area; hyprctl keyword animation 'fadeOut,1,4,default'";
    exec-once = [
      "foot --server &"
      "swww init"
      "swww img ~/dl/blue-blossom.jpg"
    ];
    input = {
      kb_options = "caps:escape";
      repeat_rate = 60;
      repeat_delay = 250;
      force_no_accel = 1;
    };
    dwindle = {
      force_split = 2;
    };
    misc = {
      enable_swallow = "true";
      disable_hyprland_logo = "true";
      swallow_regex = "^(footclient).*$";
    };
    decoration = {
      rounding = 0;
      drop_shadow = "yes";
    };
    general = {
      gaps_in = 5;
      gaps_out = 10;
      border_size = 3;
    };
    animations = {
      enabled = "true";
      bezier = [
        "overshot, 0.35, 0.9, 0.1, 1.05"
        "smoothOut, 0.36, 0, 0.66, -0.56"
        "smoothIn, 0.25, 1, 0.5, 1"
        "pace, 0.46, 1, 0.29, 0.99"
      ];
      animation = [
      "fade, 1, 3, smoothIn"
      "windows, 1, 3, overshot"
      "windowsOut, 1, 3, smoothIn"
      "windowsMove, 1, 3, default"
      "workspaces, 1, 2, default"
      "specialWorkspace, 1, 2, pace, slidevert"
      ];
    };
    bindm = [
	"$mod1, mouse:272, movewindow"
	"$mod1, mouse:273, resizewindow"
    ];
    binde = [
        ",Print, exec,grimblast --notify copy area"
	",XF86AudioRaiseVolume, exec, pulsemixer --change-volume +5"
	",XF86AudioLowerVolume, exec, pulsemixer --change-volume -5"
	",XF86AudioMute, exec, pulsemixer --toggle-mute"
    ];
    bind = 
      [
        "$mod1,Print, exec,grimblast --notify copy screen"
        "$mod2, f, exec, firefox"
        "$mod1, return, exec, footclient"

	"$mod1, q, killactive,"
	"$mod1, t, fullscreen,"
	"$mod2, q, exit,"
	"$mod2, s, togglefloating,"

	"$mod1, l, cyclenext,"
	"$mod1, h, cyclenext,prev"
	"$mod1, Tab, cyclenext,"
	"$mod2, Tab, cyclenext,prev"

	"$mod2, l, resizeactive, 20 0"
	"$mod2, h, resizeactive, -20 0"
	"$mod2, j, resizeactive, 0 20"
	"$mod2, k, resizeactive, 0 -20"

	"$mod3, return, movetoworkspace, special"
	"$mod2, return, togglespecialworkspace,"
      ]
      ++ (
        builtins.concatLists (builtins.genList (
            x: let
              ws = let
                c = (x + 1) / 10;
              in
                builtins.toString (x + 1 - (c * 10));
            in [
              "$mod1, ${ws}, workspace, ${toString (x + 1)}"
              "$mod2, ${ws}, movetoworkspace, ${toString (x + 1)}"
            ]
          )
          10)
      );
    };
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
  xdg.enable = true;
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    extraConfig = {
    XDG_DOWNLOAD_DIR = "${config.home.homeDirectory}/dl";
    XDG_PICTURES_DIR = "${config.home.homeDirectory}/pix";
    };
  };
  xdg.mime.enable = true;
  services.mako = { enable = true; };
  home.file = {
  };
  home.sessionVariables = {
    EDITOR = "nvim";
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
  };

  programs.home-manager.enable = true;
}

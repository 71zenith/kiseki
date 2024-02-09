{ pkgs, inputs, config, ... }:

{
  imports = [
    ./tools.nix
  ];

  home.username = "zen";   
  home.homeDirectory = "/home/zen";
        
  home.stateVersion = "24.05";
  gtk = {
    iconTheme = {
      name = "Zafiro-icons-Dark";
      package = pkgs.zafiro-icons;
    };

    enable = true;
    theme = {
      package = pkgs.flat-remix-gtk;
      name = "Flat-Remix-GTK-Grey-Darkest";
    };
  };

  home.pointerCursor = {
    name = "phinger-cursors-light";
    package = pkgs.phinger-cursors;
    size = 32;
    x11.enable = true;
    gtk.enable = true;
  };

  qt = {
    enable = true;
  };
  wayland.windowManager.hyprland = {
    enable = true;
    settings = { 
      env = [
        "LIBVA_DRIVER_NAME,nvidia"
        "XDG_SESSION_TYPE,wayland"
        "GBM_BACKEND,nvidia-drm"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        "WLR_NO_HARDWARE_CURSORS,1"
	"NIXOS_OZONE_WL,1"
        "MOZ_ENABLE_WAYLAND,1"
        "MOZ_WEBRENDER,1"
        "_JAVA_AWT_WM_NONREPARENTING,1"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        "QT_QPA_PLATFORM,wayland"
        "SDL_VIDEODRIVER,wayland"
        "GDK_BACKEND,wayland"
      ];
      "$mod1" = "ALT";
      "$mod2" = "ALTSHIFT";
      "$mod3" = "ALTCONTROL";
      "$screenshotarea" = "hyprctl keyword animation 'fadeOut,0,0,default'; grimblast --notify copy area; hyprctl keyword animation 'fadeOut,1,4,default'";
      monitor = "monitor=,preferred,1920x1080@75.00,1";
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
	"$mod2, Tab, cyclenext,"
	"$mod1, Tab, cyclenext,prev"

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
  xdg.enable = true;
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    extraConfig = {
    XDG_DOWNLOAD_DIR = "${config.home.homeDirectory}/dl";
    XDG_PICTURES_DIR = "${config.home.homeDirectory}/pix";
    };
  };
  programs.home-manager.enable = true;
  xdg.mime.enable = true;
}

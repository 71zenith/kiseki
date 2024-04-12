{
  pkgs,
  inputs,
  config,
  ...
}: let
  inherit (config.colorScheme) palette;
in {
  imports = [
    ./tools.nix
    ./mpv.nix
    ./shell.nix
    ./waybar.nix
    ./nvim.nix
    ./git.nix
    ./rofi.nix
    ./xdg.nix
    ./spotify-player.nix
    inputs.nix-colors.homeManagerModules.default
  ];

  programs.home-manager.enable = true;
  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };
  colorScheme = inputs.nix-colors.colorSchemes.oxocarbon-dark;

  home.username = "zen";
  home.homeDirectory = "/home/zen";
  home.sessionVariables = {EDITOR = "emacs -nw";};
  nixpkgs.config = import ./nixpkgs.nix;
  xdg.configFile."nixpkgs/config.nix".source = ./nixpkgs.nix;

  home.stateVersion = "24.05";
  gtk = {
    enable = true;
    iconTheme = {
      name = "Zafiro-icons-Dark";
      package = pkgs.zafiro-icons;
    };
  };
  xresources.properties = {
    "bar.background" = "#${palette.base02}";
    "bar.foreground" = "#${palette.base0B}";
    "bar.font" = "Google Sans-13";
    "window.foreground" = "#${palette.base04}";
    "window.background" = "#${palette.base02}";
    "mark.background" = "#${palette.base0A}";
  };

  home.pointerCursor = {
    x11.enable = true;
    gtk.enable = true;
  };

  qt = {enable = true;};

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
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
        "QT_QPA_PLATFORM,wayland;xcb"
        "DISABLE_QT5_COMPAT,0"
        "SDL_VIDEODRIVER,wayland"
        "GDK_BACKEND,wayland"
      ];
      "$mod1" = "ALT";
      "$mod2" = "ALTSHIFT";
      "$mod3" = "ALTCONTROL";
      "$mod4" = "SUPER";
      monitor = "HDMI-A-1,1920x1080@75.00,0x0,1";
      exec-once = [
        "foot --server &"
        "swww-daemon --format xrgb"
        "blueman-applet &"
        "wl-paste --type text --watch cliphist store &"
        "swww img $(fd . ~/nix/resources/wallpapers | sort -R | head -1) -f Mitchell -t any --transition-fps 75 --transition-duration 1"
        "pkill waybar; waybar &"
      ];
      windowrule = [
        "tile, class:neovide"
        "maximize, neovide"
        "workspace special silent,title:^(*otify*)$"
        "float, file_progress"
        "float, confirm"
        "float, dialog"
        "float, download"
        "float, notification"
        "float, error"
        "float, splash"
        "float, confirmreset"
        "float, title:Library"
        "float, title:Open File"
        "float, title:branchdialog"
      ];
      windowrulev2 = [
        "stayfocused, title:^()$,class:^(steam)$"
        "minsize 1 1, title:^()$,class:^(steam)$"
      ];
      input = {
        kb_options = "caps:escape";
        repeat_rate = 60;
        repeat_delay = 250;
        force_no_accel = 1;
      };
      dwindle = {
        force_split = 2;
        pseudotile = true;
        preserve_split = true;
      };
      misc = {
        enable_swallow = true;
        disable_hyprland_logo = true;
        swallow_regex = "^(footclient).*$";
      };
      decoration = {
        rounding = 10;
        drop_shadow = false;
      };
      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 3;
      };
      animations = {
        enabled = true;
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
          "layers, 1, 3, pace, slide"
          "specialWorkspace, 1, 3, pace, slidevert"
        ];
      };
      bindm = ["$mod1, mouse:272, movewindow" "$mod1, mouse:273, resizewindow"];
      bindr = ["SUPER, SUPER_L, exec, pkill rofi || rofi -show drun"];
      bindel = [
        ",Print, exec,grimblast --notify copy area"
        ",XF86AudioRaiseVolume, exec, pulsemixer --change-volume +5"
        ",XF86AudioLowerVolume, exec, pulsemixer --change-volume -5"
        ",XF86AudioMute, exec, pulsemixer --toggle-mute"
        ",XF86AudioNext, exec, playerctl next --player=spotify_player"
        ",XF86AudioPrev, exec, playerctl previous --player=spotify_player"
        ",XF86AudioPlay, exec, playerctl play-pause"
      ];
      binde = [
        "$mod2, l, resizeactive, 40 0"
        "$mod2, h, resizeactive, -40 0"
        "$mod2, j, resizeactive, 0 40"
        "$mod2, k, resizeactive, 0 -40"
      ];
      bind =
        [
          "$mod1,Print, exec,grimblast --notify copy screen"
          "$mod2, f, exec, firefox"
          "$mod1, return, exec, footclient"
          "$mod2, e, exec, emacs"
          "$mod2, v, exec, neovide"
          "$mod1, e, exec, emacsclient --create-frame"
          "$mod4, o, exec, wl-paste | cut -d \\& -f1 | xargs mpv"
          "$mod2, i, exec, swww img $(fd . ~/nix/resources/wallpapers | sort -R | head -1) -f Mitchell -t any --transition-fps 75 --transition-duration 2"
          "$mod4, v, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy"

          "$mod1, q, killactive,"
          "$mod1, t, fullscreen,"
          "$mod2, q, exit,"
          "$mod2, s, togglefloating,"

          "$mod1, l, cyclenext,"
          "$mod1, h, cyclenext,prev"
          "$mod2, Tab, cyclenext,"
          "$mod2, Tab, bringactivetotop,"
          "$mod1, Tab, cyclenext,prev"
          "$mod1, Tab, bringactivetotop,"
          "$mod3, l, swapnext"
          "$mod3, h, swapnext,prev"

          "$mod3, return, movetoworkspace, special"
          "$mod2, return, togglespecialworkspace,"
          "$mod4, return, togglespecialworkspace, pop"
        ]
        ++ (builtins.concatLists (builtins.genList (x: let
            ws = let c = (x + 1) / 10; in builtins.toString (x + 1 - (c * 10));
          in [
            "$mod1, ${ws}, workspace, ${toString (x + 1)}"
            "$mod2, ${ws}, movetoworkspacesilent, ${toString (x + 1)}"
          ])
          10));
    };
  };
}

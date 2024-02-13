{ pkgs, inputs, ... }:

{
  imports = [
    ./tools.nix
    ./mpv.nix
    ./shell.nix
    ./waybar.nix
    ./nvim.nix
    ./git.nix
    ./xdg.nix
    ./spotify-player.nix
    inputs.nix-colors.homeManagerModules.default
  ];

  programs.home-manager.enable = true;

  colorScheme = inputs.nix-colors.colorSchemes.oxocarbon-dark;

  home.username = "zen";
  home.homeDirectory = "/home/zen";
  home.sessionVariables = { EDITOR = "nvim"; };

  home.stateVersion = "24.05";
  gtk = {
    enable = true;
    iconTheme = {
      name = "Zafiro-icons-Dark";
      package = pkgs.zafiro-icons;
    };
  };

  home.pointerCursor = {
    x11.enable = true;
    gtk.enable = true;
  };

  qt = {
    enable = true;
  };

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
        "QT_QPA_PLATFORM,wayland"
        "SDL_VIDEODRIVER,wayland"
        "GDK_BACKEND,wayland"
      ];
      "$mod1" = "ALT";
      "$mod2" = "ALTSHIFT";
      "$mod3" = "ALTCONTROL";
      "$mod4" = "SUPER";
      "$screenshotarea" =
        "hyprctl keyword animation 'fadeOut,0,0,default'; grimblast --notify copy area; hyprctl keyword animation 'fadeOut,1,4,default'";
      monitor = "monitor=,preferred,1920x1080@75.00,1";
      exec-once = [
        "foot --server &"
        "swww init"
        "blueman-applet &"
        "wl-paste --type text --watch cliphist store &"
        "swww img ~/nix/resources/blue-blossom.jpg &"
        "pkill waybar; waybar &"
        "hyprctl dispatch exec 'footclient -T spotify_player spotify_player'"
      ];
      windowrule = [
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
        enable_swallow = "true";
        disable_hyprland_logo = "true";
        swallow_regex = "^(footclient).*$";
      };
      decoration = {
        rounding = 0;
        drop_shadow = "true";
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
      bindm =
        [ "$mod1, mouse:272, movewindow" "$mod1, mouse:273, resizewindow" ];
      binde = [
        ",Print, exec,grimblast --notify copy area"
        ",XF86AudioRaiseVolume, exec, pulsemixer --change-volume +5"
        ",XF86AudioLowerVolume, exec, pulsemixer --change-volume -5"
        ",XF86AudioMute, exec, pulsemixer --toggle-mute"
        ",XF86AudioNext, exec, playerctl next --player=spotify_player"
        ",XF86AudioPrev, exec, playerctl previous --player=spotify_player"
        ",XF86AudioPlay, exec, playerctl play-pause"
      ];
      bind = [
        "$mod1,Print, exec,grimblast --notify copy screen"
        "$mod2, f, exec, firefox"
        "$mod1, return, exec, footclient"
        "$mod2, e, exec, emacs"
        "$mod2, p, exec, rofi -show calc"
        "$mod1, p, exec, rofi -show drun"
        "$mod1, o, exec, rofi -show emoji"
        "$mod4, V, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy"

        "$mod1, q, killactive,"
        "$mod1, t, fullscreen,"
        "$mod2, q, exit,"
        "$mod2, s, togglefloating,"

        "$mod1, l, cyclenext,"
        "$mod1, h, cyclenext,prev"
        "$mod2, Tab, cyclenext,"
        "$mod1, Tab, cyclenext,prev"

        "$mod2, l, resizeactive, 40 0"
        "$mod2, h, resizeactive, -40 0"
        "$mod2, j, resizeactive, 0 40"
        "$mod2, k, resizeactive, 0 -40"

        "$mod4 SHIFT, l, swapnext"
        "$mod4 SHIFT, h, swapnext,prev"

        "$mod4, 49, togglegroup,"
        "$mod4, tab, changegroupactive,"
        "$mod4 SHIFT, tab, changegroupactive,b"

        "$mod3, return, movetoworkspace, special"
        "$mod2, return, togglespecialworkspace,"
      ] ++ (builtins.concatLists (builtins.genList (x:
        let ws = let c = (x + 1) / 10; in builtins.toString (x + 1 - (c * 10));
        in [
          "$mod1, ${ws}, workspace, ${toString (x + 1)}"
          "$mod2, ${ws}, movetoworkspacesilent, ${toString (x + 1)}"
        ]) 10));
    };
  };
}

{
  inputs,
  pkgs,
  lib,
  ...
}: let
  scripts = import ../../../pkgs/scripts.nix {inherit pkgs lib;};
in {
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
        "QT_QPA_PLATFORMTHEME,gtk3"
        "ELECTRON_OZONE_PLATFORM_HINT,wayland"
        "DISABLE_QT5_COMPAT,0"
        "CALIBRE_USE_DARK_PALETTE,1"
        "SDL_VIDEODRIVER,wayland"
        "GDK_BACKEND,wayland"
      ];
      "$mod1" = "SUPER";
      "$mod2" = "SUPERSHIFT";
      "$mod3" = "SUPERCONTROL";
      "$mod4" = "ALT";
      "$setwall" = "swww img $(fd . ${inputs.self}/resources/wallpapers | sort -R | head -1) -f Mitchell -t any --transition-fps 75 --transition-duration 2";
      monitor = "HDMI-A-1,1920x1080@75.00,0x0,1";
      exec-once = [
        "pgrep waybar || waybar &"
        "foot --server &"
        "swww-daemon --format xrgb"
        "wl-paste --type text --watch cliphist store &"
        "$setwall &"
      ];
      windowrule = [
        "tile, class:neovide"
        "maximize, neovide"
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
      layerrule = [
        "noanim, selection"
      ];
      windowrulev2 = [
        "stayfocused, title:^()$,class:^(steam)$"
        "minsize 1 1, title:^()$,class:^(steam)$"
        "tile, class:Nsxiv,xwayland:1"
      ];
      workspace = [
        "special:music,on-created-empty:footclient -T spotify_player spotify_player"
        "special:neorg,on-created-empty:footclient -T neorg nvim -c 'Neorg index'"
      ];
      input = {
        kb_options = "caps:escape,altwin:swap_lalt_lwin";
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
        swallow_regex = "^(foot).*$";
      };
      decoration = {
        rounding = 10;
        drop_shadow = false;
      };
      general = {
        gaps_in = 4;
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
          "windowsOut, 1, 3, smoothOut"
          "windowsMove, 1, 3, pace, slide"
          "workspaces, 1, 2, default"
          "layers, 1, 2, pace, slide"
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
        "$mod4, d, exec, playerctl next --player=spotify_player"
        "$mod4, a, exec, playerctl previous --player=spotify_player"
        "$mod4, s, exec, playerctl play-pause"
        "$mod4, n, exec, playerctld shift up"
        "$mod4, m, exec, playerctld shift down"
      ];
      binde = [
        "$mod2, l, resizeactive, 40 0"
        "$mod2, h, resizeactive, -40 0"
        "$mod2, j, resizeactive, 0 40"
        "$mod2, k, resizeactive, 0 -40"
      ];
      bind =
        [
          "$mod1, Print, exec, grimblast --notify copy screen"
          "$mod2, f, exec, firefox"
          "$mod1, return, exec, footclient"
          "$mod2, e, exec, emacs"
          "$mod2, v, exec, neovide"
          "$mod1, e, exec, emacsclient --create-frame"
          "$mod2, i, exec, $setwall"
          "$mod4, v, exec, cliphist list | rofi -dmenu -i -p '' | cliphist decode | wl-copy"
          "$mod4, c, exec, rofi -show calc -modi calc -no-show-math -no-sort -calc-command 'echo '{result}' | wl-copy'"
          "$mod4, o, exec, ${scripts.wlOcr}"
          "$mod4, p, exec, ${scripts.openMedia}"
          "$mod4, u, exec, ${scripts.rofiGuard}"
          "$mod4, i, exec, ${scripts.transLiner}"

          "$mod1, q, killactive,"
          "$mod1, t, fullscreen,"
          "$mod2, t, fullscreen,1"
          "$mod2, q, exit,"
          "$mod2, r, exec, hyprctl reload"
          "$mod2, s, togglefloating,"

          "$mod1, l, cyclenext,"
          "$mod1, h, cyclenext,prev"
          "$mod1, Tab, cyclenext,"
          "$mod1, Tab, bringactivetotop,"
          "$mod2, Tab, bringactivetotop,"
          "$mod2, Tab, cyclenext,prev"
          "$mod3, l, swapnext"
          "$mod3, h, swapnext,prev"

          "$mod2, 9, movetoworkspacesilent, special:music"
          "$mod2, 0, movetoworkspacesilent, special:neorg"
          "$mod1, 9, togglespecialworkspace, music"
          "$mod1, 0, togglespecialworkspace, neorg"
          "$mod2, return, togglespecialworkspace, music"
          "$mod3, return, togglespecialworkspace, neorg"
        ]
        ++ (builtins.concatLists (builtins.genList (x: let
            ws = let c = (x + 1) / 10; in builtins.toString (x + 1 - (c * 10));
          in [
            "$mod1, ${ws}, workspace, ${toString (x + 1)}"
            "$mod2, ${ws}, movetoworkspacesilent, ${toString (x + 1)}"
          ])
          8));
    };
  };
}

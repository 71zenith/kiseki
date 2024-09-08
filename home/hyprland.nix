{
  pkgs,
  config,
  lib,
  osConfig,
  ...
}: let
  rgb = color: "rgb(${color})";
  inherit (config.stylix.base16Scheme) palette;
  scripts = import ../pkgs/scripts.nix {inherit pkgs lib config;};
in {
  # FIXME: do not anger me; fuck hyprpaper
  services.hyprpaper.enable = lib.mkForce false;
  stylix.targets.hyprpaper.enable = lib.mkForce false;
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    extraConfig = ''
      submap = close
      bind = ,mouse:272, killactive
      bind = ,escape, submap, reset
      bind = ,mouse:272, submap, reset
      bind = ,mouse:273, submap, reset
      submap = reset
      submap = move
      bindm = ,mouse:272, movewindow
      bind = ,mouse:273, submap, reset
      submap = reset
      submap = resize
      bindm = ,mouse:272, resizewindow
      bind = ,mouse:273, submap, reset
      submap = reset
    '';
    settings = {
      env = [
        "LIBVA_DRIVER_NAME,nvidia"
        "XDG_SESSION_TYPE,wayland"
        "GBM_BACKEND,nvidia-drm"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        "VDPAU_DRIVER,nvidia"
        "WLR_NO_HARDWARE_CURSORS,1"
        "NIXOS_OZONE_WL,1"
        "GRIMBLAST_EDITOR,satty --filename"
        "ELECTRON_OZONE_PLATFORM_HINT,auto"
        "MOZ_ENABLE_WAYLAND,1"
        "NVD_BACKEND,direct"
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
      "$setwall" = "swww img $(fd . ${pkgs.my-walls}/share/wallpapers/ | sort -R | head -1) -f Mitchell -t any --transition-fps 75 --transition-duration 2";
      monitor = [
        # FIXME: annoying ahh kernel bug
        "Unknown-1,disabled"
        "HDMI-A-1,1920x1080@75.00,0x0,1"
      ];
      exec-once = [
        "foot --server &"
        "swww-daemon --format xrgb"
        "wl-paste --type text --watch cliphist store &"
        "wl-paste --type image --watch cliphist store &"
        "$setwall &"
      ];
      exec = [
        "pgrep waybar || waybar &"
        "pgrep eww || eww open lyrics &"
        "${lib.getExe pkgs.xorg.xrdb} -merge $HOME/.Xresources &"
      ];
      windowrule = [
        "noblur, GLava"
        "noborder, GLava"
        "noshadow, GLava"
        "noanim, GLava"
        "nofocus, GLava"
        "float, GLava"
        "pin, GLava"
        "idleinhibit always, GLava"
        "size 100% 100%, GLava"
        "move 0 0, GLava"
      ];
      layerrule = [
        "noanim, selection"
      ];
      windowrulev2 = [
        "stayfocused, title:^()$,class:^(steam)$"
        "minsize 1 1, title:^()$,class:^(steam)$"
        "float, class:io.github.Qalculate.qalculate-qt"
        "size 70% 55%, class:io.github.Qalculate.qalculate-qt"
        "center, class:io.github.Qalculate.qalculate-qt"
        "float, title:quick"
        "size 80% 75%, title:quick"
        "center, title:quick"
        "size 85% 80%, class:com.gabm.satty"
        "center, class:com.gabm.satty"
        "center, class:foot"
        "idleinhibit always, title:raylib-zig dvd animation"
        "idleinhibit always, class:steam_app_0"
        "tile, class:Nsxiv,xwayland:1"
        "workspace special:mpv silent, initialTitle:mpvplay"
        "tile, title:Neovide,class:neovide"
      ];
      workspace = [
        "special:music, on-created-empty:${scripts.openFoot} 18 spotify_player"
      ];
      input = {
        kb_options = osConfig.services.xserver.xkb.options;
        repeat_rate = 60;
        repeat_delay = 250;
        force_no_accel = 1;
      };
      dwindle = {
        force_split = 2;
        no_gaps_when_only = false;
        pseudotile = false;
        preserve_split = true;
      };
      misc = {
        font_family = config.stylix.fonts.serif.name;
        enable_swallow = true;
        force_default_wallpaper = 0;
        new_window_takes_over_fullscreen = 1;
        disable_splash_rendering = true;
        disable_hyprland_logo = true;
        swallow_regex = "^(foot).*$";
      };
      decoration = {
        rounding = 12;
        blur = {
          enabled = true;
          noise = 0;
        };
        drop_shadow = true;
        shadow_range = 15;
        dim_inactive = true;
        dim_strength = 0.1618;
      };
      binds.workspace_back_and_forth = true;
      general = {
        gaps_in = 5;
        gaps_out = 8;
        border_size = 0;
        "col.active_border" = lib.mkForce (rgb palette.base0A);
      };
      group = {
        "col.border_inactive" = lib.mkForce (rgb palette.base0D);
        "col.border_active" = lib.mkForce (rgb palette.base06);
        "col.border_locked_active" = lib.mkForce (rgb palette.base06);
      };
      cursor = {
        no_hardware_cursors = true;
      };
      blurls = ["waybar"];
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
      bindm = [
        "$mod1, mouse:272, movewindow"
        "$mod1, mouse:273, resizewindow"
      ];
      bindr = ["SUPER, SUPER_L, exec, pkill rofi || rofi -show drun"];
      bindel = [
        ",Print, exec,grimblast --notify copy area"
        ",XF86AudioRaiseVolume, exec, pulsemixer --change-volume +5"
        ",XF86AudioLowerVolume, exec, pulsemixer --change-volume -5"
        ",XF86AudioMute, exec, pulsemixer --toggle-mute"
        ",XF86AudioNext, exec, playerctl next --player=spotify_player"
        ",XF86AudioPrev, exec, playerctl previous --player=spotify_player"
        ",XF86AudioPlay, exec, playerctl play-pause"
        "$mod1, d, exec, playerctl next --player=spotify_player"
        "$mod1, a, exec, playerctl previous --player=spotify_player"
        "$mod1, s, exec, playerctl play-pause"
        "$mod1, n, exec, playerctld shift"
        "$mod1, m, exec, playerctld unshift"
      ];
      binde = [
        "$mod2, l, resizeactive, 40 0"
        "$mod2, h, resizeactive, -40 0"
        "$mod2, j, resizeactive, 0 40"
        "$mod2, k, resizeactive, 0 -40"

        "$mod3, l, moveactive, 60 0"
        "$mod3, h, moveactive, -60 0"
        "$mod3, j, moveactive, 0 60"
        "$mod3, k, moveactive, 0 -60"

        "$mod1, left, movewindow, l"
        "$mod1, right, movewindow, r"
        "$mod1, down, movewindow, d"
        "$mod1, up, movewindow, u"
      ];
      bind =
        [
          "$mod1, Print, exec, grimblast --notify copy screen"
          "$mod4, Print, exec, grimblast --notify edit area"

          "$mod2, f, exec, firefox"
          "$mod2, v, exec, neovide"
          "$mod2, e, exec, emacs"
          "$mod2, p, exec, qbittorrent"
          "$mod2, g, exec, heroic"
          "$mod2, b, submap, close"
          "$mod2, i, exec, $setwall"
          "$mod2, o, exec, rofi -theme preview -show filebrowser -selected-row 1"

          "$mod1, c, exec, rofi -show calc -modi calc -no-show-math -no-sort -calc-command 'echo '{result}' | wl-copy'"
          "$mod1, e, exec, echo ytdl://ytsearch:\"$(playerctl metadata --format '{{artist}} {{title}} {{album}}')\" | wl-copy && ${scripts.openMedia}"
          "$mod1, r, exec, pkill qalculate-qt || qalculate-qt"
          "$mod1, z, exec, pkill pulsemixer || footclient -T quick pulsemixer"

          "$mod1, return, exec, footclient"
          "$mod1, semicolon, exec, mpv --input-ipc-server=/tmp/mpvsocket --no-resume-playback --player-operation-mode=pseudo-gui"
          "$mod1, comma, exec, pkill btop || footclient -T quick btop"
          "$mod1, period, exec, ${lib.getExe pkgs.hdrop} -b -f -g 230 -w 85 -h 65 -c foot 'footclient -a foot'"
          "$mod1, slash, exec, eww open romaji --toggle"

          "$mod1, o, exec, ${scripts.wlOcr}"
          "$mod1, p, exec, ${scripts.openMedia}"
          "$mod1, u, exec, ${scripts.rofiGuard}"
          "$mod1, w, exec, ${scripts.epubOpen}"
          "$mod1, i, exec, ${scripts.transLiner}"
          "$mod1, y, exec, ${scripts.copyVid}"
          "$mod1, v, exec, ${scripts.clipShow}"
          "$mod1, g, exec, ${scripts.glavaShow}"
          "$mod1, b, exec, ${scripts.torMpv}"
          "$mod1, bracketleft, exec, ${scripts.copyPalette} glava"
          "$mod1, bracketright, exec, ${scripts.copyPalette} eww"
          "$mod1, apostrophe, exec, ${scripts.floatToggle}"

          "$mod1, q, killactive,"
          "$mod1, x, togglesplit,"
          "$mod1, t, fullscreen,"
          "$mod1, f, fullscreenstate, -1 2"
          "$mod2, t, fullscreen, 1"
          "$mod2, q, exit,"
          "$mod2, r, exec, hyprctl reload"
          "$mod2, s, togglefloating,"

          "$mod1, mouse_down, workspace, r+1"
          "$mod1, mouse_up, workspace, r-1"

          "$mod1, l, cyclenext,"
          "$mod1, h, cyclenext, prev"
          "$mod1, Tab, cyclenext,"
          "$mod1, Tab, bringactivetotop,"
          "$mod2, Tab, bringactivetotop,"
          "$mod2, Tab, cyclenext, prev"
          "$mod3, n, swapnext"
          "$mod3, p, swapnext, prev"

          "$mod1, 9, togglespecialworkspace, music"
          "$mod2, 9, movetoworkspacesilent, special:music"
          "$mod2, return, togglespecialworkspace, music"
          "$mod1, 0, togglespecialworkspace, mpv"
          "$mod2, 0, movetoworkspacesilent, special:mpv"
          "$mod3, return, togglespecialworkspace, mpv"
        ]
        ++ (builtins.concatLists (builtins.genList (x: let
            ws = let c = (x + 1) / 10; in toString (x + 1 - (c * 10));
          in [
            "$mod1, ${ws}, workspace, ${toString (x + 1)}"
            "$mod2, ${ws}, movetoworkspacesilent, ${toString (x + 1)}"
          ])
          8));
    };
  };
}

{pkgs, ...}: {
  wayland.windowManager.river = {
    enable = true;
    systemd.enable = true;
    settings = {
      layout = "rivertile";
      default-layout = "rivertile";
      border-width = 3;
      set-repeat = "60 250";
      spawn = [
        "rivertile -view-padding 3 -outer-padding 6 -main-ratio 0.5 &"
        "foot --server &"
        "swww-daemon --format xrgb"
        "pgrep waybar || waybar &"
        "wl-paste --type text --watch cliphist store &"
        "swww img $(fd . ${pkgs.my-walls}/share/wallpapers/ | sort -R | head -1) -f Mitchell -t any --transition-fps 75 --transition-duration 2 --resize fit"
      ];
      rule-add = {
        "-app-id" = {
          "'*'" = "ssd";
        };
      };
      map = let
        mod1 = "Alt";
        mod2 = "Alt+Shift";
        mod3 = "Alt+Control";
      in {
        normal = {
          "${mod2}+F" = "spawn 'firefox'";
          "${mod1}+E" = "spawn 'emacs'";
          "${mod1}+V" = "spawn 'neovide'";
          "${mod1}+Return" = "spawn 'footclient'";

          "${mod1}+BTN_LEFT" = "move-view";
          "${mod1}+BTN_RIGHT" = "resize-view";

          "${mod1}+Q" = "close";
          "${mod1}+t" = "toggle-fullscreen";
          "${mod2}+s" = "toggle-float";
          "${mod2}+Q" = "exit";
          "${mod1}+Tab" = "focus-view next";
          "${mod1}+L" = "focus-view right";
          "${mod1}+H" = "focus-view left";
          "${mod1}+J" = "focus-view down";
          "${mod1}+K" = "focus-view up";
          "${mod3}+L" = "swap right";
          "${mod3}+H" = "swap left";
          "${mod3}+J" = "swap down";
          "${mod3}+K" = "swap up";
          "${mod2}+L" = "resize horizontal 40";
          "${mod2}+H" = "resize horizontal -40";
          "${mod2}+J" = "resize vertical 40";
          "${mod2}+K" = "resize vertical -40";

          "-repeat None XF86AudioRaiseVolume" = "spawn 'pulsemixer --change-volume +5'";
          "-repeat None XF86AudioLowerVolume" = "spawn 'pulsemixer --change-volume -5'";
          "None XF86AudioLowerMute" = "spawn 'pulsemixer --toggle-mute'";
          "None XF86AudioNext" = "spawn 'playerctl next --player=spotify_player'";
          "None XF86AudioPrev" = "spawn 'playerctl previous --player=spotify_player'";
          "None XF86AudioPlay" = "spawn 'playerctl play-pause'";

          "${mod1}+D" = "spawn 'playerctl next --player=spotify_player'";
          "${mod1}+A" = "spawn 'playerctl previous --player=spotify_player'";
          "${mod1}+S" = "spawn 'playerctl play-pause'";
          "${mod1}+N" = "spawn 'playerctld shift up'";
          "${mod1}+M" = "spawn 'playerctld shift down'";

          "${mod1}+1" = "set-focused-tags 1";
          "${mod1}+2" = "set-focused-tags 2";
          "${mod1}+3" = "set-focused-tags 3";
          "${mod1}+4" = "set-focused-tags 4";
          "${mod1}+5" = "set-focused-tags 5";
          "${mod1}+6" = "set-focused-tags 6";
          "${mod1}+7" = "set-focused-tags 7";
          "${mod1}+8" = "set-focused-tags 8";

          "${mod2}+1" = "set-view-tags 1";
          "${mod2}+2" = "set-view-tags 2";
          "${mod2}+3" = "set-view-tags 3";
          "${mod2}+4" = "set-view-tags 4";
          "${mod2}+5" = "set-view-tags 5";
          "${mod2}+6" = "set-view-tags 6";
          "${mod2}+7" = "set-view-tags 7";
          "${mod2}+8" = "set-view-tags 8";
        };
      };
    };
  };
}

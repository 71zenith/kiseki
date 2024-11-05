{
  osConfig,
  config,
  pkgs,
  lib,
  ...
}: let
  scripts = import ../pkgs/scripts.nix {inherit pkgs lib config;};
in {
  stylix.targets.waybar = {
    enableLeftBackColors = false;
    enableRightBackColors = false;
    enableCenterBackColors = false;
  };
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        modules-left = ["hyprland/workspaces" "group/win"];
        modules-center = ["image#cover" "group/music"];
        modules-right = ["network" "pulseaudio" "clock#date" "clock#time" "gamemode" "group/custom" "privacy" "tray"];
        "hyprland/workspaces" = {
          format = "{icon}";
          show-special = true;
          on-scroll-up = "hyprctl dispatch workspace r-1";
          on-scroll-down = "hyprctl dispatch workspace r+1";
          format-icons = {
            "music" = "";
            "mpv" = "";
          };
          persistent-workspaces = {
            "1" = [];
            "2" = [];
            "3" = [];
            "4" = [];
            "5" = [];
            "6" = [];
            "7" = [];
            "8" = [];
            "special:music" = [];
          };
          ignore-workspaces = ["special:hdrop"];
        };
        "group/win" = {
          orientation = "inherit";
          drawer.transition-duration = 250;
          modules = [
            "hyprland/window"
            "wlr/taskbar"
          ];
        };
        "wlr/taskbar" = {
          active-first = true;
          markup = true;
          on-click = "activate";
          on-click-middle = "close";
          ignore-list = ["GLava"];
          icon-size = 24;
        };
        "hyprland/window" = {
          icon = true;
          rewrite = {
            ".+" = "";
          };
        };
        "tray" = {spacing = 10;};
        "clock#time" = {
          format = "{:%H:%M}";
          tooltip-format = "{tz_list}";
          timezones = [
            osConfig.time.timeZone
            "Europe/Berlin"
            "Asia/Tokyo"
          ];
        };
        "clock#date" = {
          format = "{:%a %d %b}";
          tooltip-format = "<tt><big>{calendar}</big></tt>";
        };
        "network" = {
          format-ethernet = "{bandwidthUpBytes} {bandwidthDownBytes}";
          min-width = 20;
          fixed-width = 20;
          interface = "enp7s0";
          interval = 1;
        };
        "pulseaudio" = {
          format = "{volume}%";
          format-muted = "{volume}%";
          on-click = "pulsemixer --toggle-mute";
          on-scroll-up = "pulsemixer --change-volume +5";
          on-scroll-down = "pulsemixer --change-volume -5";
          on-click-right = "pkill pulsemixer || footclient -T quick pulsemixer";
        };
        "privacy" = {
          icon-size = 16;
          icon-spacing = 5;
          on-click = "pkill glava";
        };
        "idle_inhibitor" = {
          format = "{icon}";
          on-click-right = "hyprlock";
          format-icons = {
            activated = "";
            deactivated = "";
          };
        };
        "group/custom" = {
          orientation = "inherit";
          drawer = {
            transition-left-to-right = false;
            transition-duration = 250;
          };
          modules = [
            "image#toggle"
            "custom/power"
            "hyprland/submap"
            "idle_inhibitor"
            "custom/osk"
            "custom/gammastep"
          ];
        };
        "image#toggle" = {
          exec = pkgs.writeShellScript "floatOrToggle" ''
            [ -e "/tmp/hypr.float" ] && echo ${pkgs.my-misc}/share/misc/defense_quartz.png || echo ${pkgs.my-misc}/share/misc/wind_quartz.png
          '';
          signal = 11;
          size = 23;
          on-click = "pkill rofi || rofi -show drun";
          on-click-middle = scripts.floatToggle;
          on-click-right = "swww img $(fd . ${pkgs.my-walls}/share/wallpapers/ | sort -R | head -1) -f Mitchell -t any --transition-fps 75 --transition-duration 2";
          tooltip-format = "open quick settings";
        };
        "hyprland/submap" = {
          always-on = true;
          default-submap = "󰇀";
          on-click = "hyprctl dispatch submap ";
          on-click-middle = "hyprctl dispatch submap ";
          on-click-right = "hyprctl dispatch submap 󰙖";
        };
        "custom/power" = {
          format = "";
          on-click = "reboot";
          on-click-right = "poweroff";
          tooltip-format = "reboot/poweroff";
        };
        "custom/osk" = {
          return-type = "json";
          format = "";
          signal = 10;
          exec = pkgs.writeShellScript "updateOsk" ''
            if pgrep wvkbd >/dev/null; then
              echo "{ \"class\" : \"on\", \"tooltip\" : \"deactivate wvbkd\" }"
            else
              echo "{ \"class\" : \"off\", \"tooltip\" : \"activate wvbkd\" }"
            fi
          '';
          on-click = with config.stylix.base16Scheme.palette;
            pkgs.writeShellScript "oskToggle" ''
              pkill wvkbd-mobintl || setsid wvkbd-mobintl -L 200 --bg ${base00} --fg ${base01} --press ${base0C} --fg-sp ${base02} --press-sp ${base0B} --alpha 240 --text ${base05} --text-sp ${base05} --fn "${config.stylix.fonts.serif.name} ${toString config.stylix.fonts.sizes.desktop}" &
              pkill -RTMIN+10 waybar
            '';
        };
        "custom/gammastep" = {
          return-type = "json";
          format = "";
          signal = 9;
          exec = pkgs.writeShellScript "updateGamma" ''
            if pgrep gammastep >/dev/null; then
              echo "{ \"class\" : \"on\", \"tooltip\" : \"deactivate gammastep\" }"
            else
              echo "{ \"class\" : \"off\", \"tooltip\" : \"activate gammastep\" }"
            fi
          '';
          on-click = pkgs.writeShellScript "gammaToggle" ''
            pkill gammastep || setsid gammastep -O 4500 &
            pkill -RTMIN+9 waybar
          '';
        };
        "group/music" = {
          orientation = "vertical";
          modules = [
            "mpris"
            "custom/progress"
          ];
        };
        "mpris" = with config.lib.stylix.colors.withHashtag; {
          format = "{dynamic}";
          format-paused = "<span foreground='${base02}'><i>{dynamic}</i></span>";
          dynamic-order = ["title" "artist"];
          dynamic-separator = "<span foreground='${base03}' weight='heavy'> • </span>";
          on-scroll-up = "playerctld shift";
          on-scroll-down = "playerctld unshift";
          max-length = 100;
        };
        "custom/progress" = {
          return-type = "json";
          exec = pkgs.writeShellScript "centWay" ''
            while :; do
              echo "{ \"text\" : \"_\" , \"class\" : \"$(playerctl --ignore-player firefox metadata --format 'cent{{ (position / 100) / (mpris:length / 100) * 100 }}' | cut -d. -f1)\" }"
              sleep 1
            done
          '';
        };
        "image#cover" = {
          on-click = "pkill nsxiv || nsxiv /tmp/cover.jpg";
          on-click-right = "spotify_player like";
          on-click-middle = scripts.glavaShow;
          path = "/tmp/cover.jpg";
          size = 31;
          signal = 8;
        };
      };
    };
    style =
      ''
        * { border: 0; border-radius: 0; min-height: 0; }
        * { font-family: ${builtins.concatStringsSep "," (map (font: ''"${font}"'') osConfig.fonts.fontconfig.defaultFonts.sansSerif)}; }
        #waybar { transition: background-color .1s; }
        #waybar.hidden { opacity: .1; }


        #clock, #mpris, #network, #tray, #pulseaudio, #workspaces, #image.toggle,
        #privacy, #gamemode, #custom-power, #custom-gammastep, #custom-osk, #submap {
          color: @base05;
          padding: 2px 4px;
          background-color: alpha(@base00, 0);
          margin: 2px 4px;
        }

        #image.cover { margin: 4px 0; }
        #workspaces button {
          color: @base04;
          box-shadow: inset 0 -3px transparent;
          padding: 0 6px;
          transition: all .1s cubic-bezier(.55, -.68, .48, 1.68);
        }
        #workspaces button.empty { color: @base03; }
        #workspaces button.active { color: @base0B; }

        #mpris { margin-top: 1px; margin-bottom: 1px; color: @base09; }
        #pulseaudio { color: @base0D; }
        #pulseaudio.muted, #network.disconnected { color: @base0A; }
        #network { color: @base0F; }
        #clock.time { color: @base0E; }
        #clock.date { color: @base08; }

        tooltip { padding: 3px; background-color: alpha(@base01, .75); }
        #tray > .passive { -gtk-icon-effect: dim; }
        #tray > .needs-attention { -gtk-icon-effect: highlight; background-color: @base0A; }

        #custom-power, #custom-gammastep, #submap, #custom-osk { margin: 0 1px; }
        #taskbar button:hover, #custom-power:hover, #custom-gammastep:hover,
        #submap:hover, #custom-osk:hover, #idle_inhibitor:hover { background-color: @base01; }

        #window { margin-bottom: 2px; margin-right: 0; padding-right: 0; }
        #taskbar { margin-bottom: 2px; margin-left: 0; padding-left: 0; }
        #taskbar button { padding: 0 7px; }

        #privacy, #gamemode, #image.toggle { margin: 0 2px; padding: 0 2px; }
        #custom-power, #custom-gammastep.on, #submap, #custom-osk.on, #idle_inhibitor.activated { color: @base09; }
        #custom-gammastep.off, #custom-osk.off, #idle_inhibitor.deactivated { color: @base02; }

        #custom-progress {
          font-size: 2pt;
          margin: 2px 7px 0;
          color: transparent;
        }''
      + builtins.concatStringsSep "\n" (map (p: ''
        #custom-progress.cent${toString p} {
          background: linear-gradient(to right, @base07 ${toString p}%, @base01 ${toString p}.1%);
        }
      '') (lib.range 0 100));
  };
}

{
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
            "1" = "一";
            "2" = "二";
            "3" = "三";
            "4" = "四";
            "5" = "五";
            "6" = "六";
            "7" = "七";
            "8" = "八";
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
            "Asia/Kolkata"
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
        "group/music" = {
          orientation = "vertical";
          modules = [
            "mpris"
            "custom/progress"
          ];
        };
        "custom/progress" = {
          return-type = "json";
          exec = pkgs.writeShellScript "centWay" ''
            while :; do
              echo "{ \"text\" : \"_\" , \"class\" : \"$(playerctl --ignore-player firefox metadata --format 'cent{{ (position / 100) / (mpris:length / 100) * 100 }}' | cut -d. -f1)\" }"
              sleep 2.5
            done
          '';
        };
        "group/custom" = {
          orientation = "inherit";
          drawer = {
            transition-left-to-right = false;
            transition-duration = 250;
          };
          modules = [
            "image#toggle"
            "custom/off"
            "custom/again"
            "idle_inhibitor"
            "custom/shot"
            "custom/close"
            "custom/osk"
            "custom/gammastep"
          ];
        };
        "image#toggle" = {
          path = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          size = 19;
          on-click = "pkill rofi || rofi -show drun";
          on-click-right = "swww img $(fd . ${pkgs.my-walls}/share/wallpapers/ | sort -R | head -1) -f Mitchell -t any --transition-fps 75 --transition-duration 2";
          tooltip-format = "open quick settings";
        };
        "custom/off" = {
          format = "";
          on-click = "poweroff";
          tooltip-format = "poweroff";
        };
        "custom/shot" = {
          format = "";
          on-click = "grimblast --notify copy area";
          on-click-right = "grimblast --notify copy screen";
          on-click-middle = "grimblast --notify edit area";
          tooltip-format = "screenshot";
        };
        "custom/close" = {
          format = "";
          on-click = "hyprctl dispatch submap close";
          tooltip-format = "close window";
        };
        "custom/again" = {
          format = "";
          on-click = "reboot";
          tooltip-format = "reboot";
        };
        "idle_inhibitor" = {
          format = "{icon}";
          on-click-right = "dvd";
          format-icons = {
            activated = "";
            deactivated = "";
          };
        };
        "privacy" = {
          icon-size = 16;
          icon-spacing = 5;
          on-click = "pkill glava";
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
              pkill wvkbd-mobintl || setsid wvkbd-mobintl -L 200 --bg ${base00} --fg ${base01} --press ${base0C} --fg-sp ${base02} --press-sp ${base0B} --alpha 240 --text ${base05} --text-sp ${base05} &
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
        "image#cover" = {
          on-click = "pkill nsxiv || nsxiv /tmp/cover.jpg";
          on-click-right = "spotify_player like";
          on-click-middle = scripts.glavaShow;
          path = "/tmp/cover.jpg";
          size = 31;
          signal = 8;
        };
        "mpris" = {
          format = "{status_icon} {title}";
          format-paused = "{status_icon} <i>{title}</i>";
          on-scroll-up = "playerctld shift";
          on-scroll-down = "playerctld unshift";
          max-length = 80;
          status-icons = {
            playing = "";
            paused = "";
          };
        };
      };
    };
    style =
      ''
        * {
          border: none;
          border-radius: 0;
          min-height: 0;
        }
        window#waybar {
          transition-property: background-color;
          transition-duration: 0.1s;
        }
        window#waybar.hidden {
          opacity: 0.1;
        }
        #clock,
        #mpris,
        #network,
        #tray,
        #pulseaudio,
        #pulseaudio.muted,
        #taskbar,
        #workspaces,
        #image.toggle,
        #idle_inhibitor,
        #privacy,
        #gamemode,
        #custom-off,
        #custom-again,
        #custom-gammastep,
        #custom-shot,
        #custom-osk,
        #custom-close,
        #network.disconnected {
          color: @base05;
          padding: 2px 5px;
          border-radius: 5px;
          background-color: alpha(@base00, 0.0);

          margin-left: 5px;
          margin-right: 5px;

          margin-top: 2px;
          margin-bottom: 2px;
        }
        #window {
          margin-bottom: 2px;
          margin-right: 0px;
          padding-right: 0px;
        }
        #workspaces button {
          color: @base04;
          box-shadow: inset 0 -3px transparent;
          padding-right: 6px;
          padding-left: 6px;
          transition: all 0.1s cubic-bezier(0.55, -0.68, 0.48, 1.68);
        }
        #workspaces button.empty {
          color: @base03;
        }
        #workspaces button.active {
          color: @base0B;
        }
        #mpris {
          margin-top: 2px;
          color: @base09;
        }
        #pulseaudio {
          color: @base0D;
        }
        #pulseaudio.muted {
          color: @base0A;
        }
        #network {
          color: @base0F;
        }
        #network.disconnected {
          color: @base0A;
        }
        #clock.time {
          color: @base0E;
        }
        #clock.date {
          color: @base08;
        }
        tooltip {
          padding: 3px;
          background-color: alpha(@base01, 0.75);
        }
        tooltip label {
          padding: 3px;
        }
        #tray > .passive {
          -gtk-icon-effect: dim;
        }
        #tray > .needs-attention {
          -gtk-icon-effect: highlight;
          background-color: @base0A;
        }
        #idle_inhibitor:hover,
        #taskbar button:hover,
        #custom-shot:hover,
        #custom-off:hover,
        #custom-again:hover,
        #custom-gammastep:hover,
        #custom-close:hover,
        #custom-osk:hover {
          border-radius: 0px;
          background-color: @base01;
        }
        #privacy,
        #gamemode,
        #image.toggle,
        #idle_inhibitor,
        #custom-off,
        #custom-shot,
        #custom-again,
        #custom-gammastep,
        #custom-close,
        #custom-osk {
          margin-left: 1px;
          margin-right: 1px;
        }
        #taskbar {
          margin-bottom: 2px;
          margin-left: 0px;
          padding-left: 0px;
        }
        #taskbar button {
          margin-bottom: 2px;
        }
        #idle_inhibitor.activated,
        #privacy-item,
        #custom-off,
        #custom-again,
        #custom-shot,
        #custom-gammastep.on,
        #custom-close,
        #custom-osk.on {
          color: @base06;
        }
        #idle_inhibitor.deactivated,
        #custom-gammastep.off,
        #custom-osk.off {
          color: @base02;
        }
        #custom-progress {
          font-size: 2.5px;
          margin-left: 10px;
          margin-right: 10px;
          margin-top: 2px;
          color: transparent
        }
      ''
      + builtins.concatStringsSep "\n" (builtins.map (p: ''
        #custom-progress.cent${toString p} {
          background: linear-gradient(to right, @base07 ${toString p}%, @base01 ${toString p}.1%);
        }
      '') (lib.range 0 100));
  };
}

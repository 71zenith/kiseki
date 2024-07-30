{
  pkgs,
  lib,
  ...
}: {
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
        modules-left = ["group/custom" "hyprland/workspaces" "hyprland/window"];
        modules-center = ["image" "group/music"];
        modules-right = ["network" "pulseaudio" "clock#date" "clock#time" "tray"];
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
            "matrix" = "󰭻";
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
          };
          ignore-workspaces = ["special:hdrop"];
        };
        "hyprland/window" = {
          icon = true;
          rewrite = {
            ".+" = "";
          };
        };
        "tray" = {spacing = 10;};
        "clock#time" = {format = "{:%H:%M}";};
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
              echo "{ \"text\" : \"_\" , \"class\" : \"$(playerctl --player spotify_player metadata --format 'cent{{ (position / 100) / (mpris:length / 100) * 100 }}' | cut -d. -f1)\" }"
              sleep 3
            done
          '';
        };
        "group/custom" = {
          orientation = "horizontal";
          drawer = {};
          modules = [
            "custom/toggle"
            "custom/gammastep"
            "custom/osk"
            "custom/dvd"
          ];
        };
        "custom/toggle" = {
          format = "";
          tooltip-format = "open quick settings";
        };
        "custom/dvd" = {
          format = "";
          on-click = "dvd";
          tooltip-format = "activate dvd";
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
          on-click = pkgs.writeShellScript "oskToggle" ''
            pkill wvkbd-mobintl || setsid wvkbd-mobintl -L 200 --bg "161616" --fg "262626" --press "ff7eb6" --fg-sp "393939" --press-sp "33b1ff" --alpha 240 --text "f2f4f8" --text-sp "f2f4f8" &
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
        "image" = {
          on-click = "nsxiv /tmp/cover.jpg";
          path = "/tmp/cover.jpg";
          size = 29;
          signal = 8;
        };
        "mpris" = {
          format = "{status_icon} {title}";
          format-paused = "{status_icon} <i>{title}</i>";
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
        #workspaces,
        #custom-toggle,
        #custom-dvd,
        #custom-gammastep,
        #custom-osk,
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
          padding: 5px;
          background-color: alpha(@base01, 0.75);
        }
        tooltip label {
          padding: 5px;
        }
        #tray > .passive {
          -gtk-icon-effect: dim;
        }
        #tray > .needs-attention {
          -gtk-icon-effect: highlight;
          background-color: @base0A;
        }
        #custom-toggle {
          margin-right: 0px;
          color: @base0E;
        }
        #custom-dvd,
        #custom-gammastep,
        #custom-osk {
          margin-left: 2px;
          margin-right: 2px;
        }
        #custom-dvd,
        #custom-gammastep.off,
        #custom-osk.off {
          color: @base06;
        }
        #custom-gammastep.on,
        #custom-osk.on {
          color: @base0F;
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

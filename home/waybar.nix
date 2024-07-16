{
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
        modules-left = ["hyprland/workspaces" "hyprland/window"];
        modules-center = ["image" "mpris"];
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
        "image" = {
          path = "/tmp/cover.jpg";
          size = 32;
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
    style = ''
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
    '';
  };
}

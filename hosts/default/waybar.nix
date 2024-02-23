{ config, ... }:

let inherit (config.colorScheme) palette;
in {
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        height = 15;
        layer = "top";
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "mpris" ];
        modules-right =
          [ "network" "pulseaudio" "clock#date" "clock#time" "tray" ];
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
            "9" = "九";
            "10" = "十";
            "special" = "・";
          };
          persistent-workspaces = {
            "1" = [ ];
            "2" = [ ];
            "3" = [ ];
            "4" = [ ];
            "5" = [ ];
            "6" = [ ];
            "7" = [ ];
            "8" = [ ];
            "9" = [ ];
            "10" = [ ];
          };
        };
        "hyprland/window" = { max-length = 200; };
        "tray" = { spacing = 10; };
        "clock#time" = { format = "{:%H:%M}"; };
        "clock#date" = {
          format = "{:%a %d %b}";
          tooltip-format = "<tt><big>{calendar}</big></tt>";
        };
        "network" = {
          format-ethernet = "{bandwidthUpBits} {bandwidthDownBytes}";
          min-width = 20;
          fixed-width = 20;
          interface = "enp7s0";
          interval = 1;
        };
        "bluetooth" = {
          format = "{icon}";
          format-alt = "bluetooth: {status}";
          interval = 30;
          format-icons = {
            enabled = "";
            disabled = "󰂲";
          };
          tooltip-format = "{status}";
        };
        "pulseaudio" = {
          format = "{volume}%";
          format-muted = "{volume}%";
          on-click = "pulsemixer --toggle-mute";
          on-scroll-up = "pulsemixer --change-volume +5";
          on-scroll-down = "pulsemixer --change-volume -5";
        };
        "mpris" = {
          format = "{status_icon} {title}";
          format-paused = " {status_icon} <i>{title}</i>";
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
        font-family: Iosevka Comfy;
        font-size: 18px;
        border: none;
        border-radius: 0;
        min-height: 0;
      }

      window#waybar {
        background-color: rgba(16, 16, 16, 0.8);
      	color: #${palette.base04};
          transition-property: background-color;
          transition-duration: 0.1s;
        }
      window#waybar.hidden {
        opacity: 0.1;
      }
      #window {
        color: #${palette.base04};
      }
      #clock,
      #mpris, 
      #network,
      #tray,
      #pulseaudio,
      #workspaces,
      #network#disconnected {
        color: #${palette.base05};
        border-radius: 6px;
        padding: 2px 10px;
        background-color: #${palette.base00};
        border-radius: 8px;

        margin-left: 6px;
        margin-right: 6px;

        margin-top: 5px;
        margin-bottom: 5px;
      }
      #workspaces button {
        color: #${palette.base0C};
        box-shadow: inset 0 -3px transparent;

        padding-right: 7px;
        padding-left: 7px;

        transition: all 0.1s cubic-bezier(0.55, -0.68, 0.48, 1.68);
      }
      #workspaces button.empty {
        color: #${palette.base04};
        box-shadow: inset 0 -3px transparent;

        padding-right: 7px;
        padding-left: 7px;

        transition: all 0.1s cubic-bezier(0.55, -0.68, 0.48, 1.68);
      }
      #workspaces button.active {
        color: #${palette.base0B};
        padding-left: 7px;
        padding-right: 7px;
        transition: all 0.1s cubic-bezier(0.55, -0.68, 0.48, 1.68);
      }

      #pulseaudio {
        color: #${palette.base0D};
      }
      #pulseaudio.muted {
        color: #${palette.base0A};
      }
      #network {
        color: #${palette.base0F};
      }
      #network.disconnected {
        color: #${palette.base0A};
      }
      @keyframes blink {
        to {
          background-color: rgba(30, 34, 42, 0.5);
          color: #${palette.base07};
        }
      }
      #clock.time {
        color: #${palette.base0E};
      }
      #clock.date {
        color: #${palette.base08};
      }
      tooltip {
        border-radius: 15px;
        padding: 15px;
        background-color: #${palette.base01};
      }

      tooltip label {
        padding: 5px;
      }

      #tray > .passive {
        -gtk-icon-effect: dim;
      }

      #tray > .needs-attention {
        -gtk-icon-effect: highlight;
        background-color: #${palette.base0A};
      }
      #mpris {
        color: #${palette.base09};
      }
    '';
  };
}

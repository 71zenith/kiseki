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
        height = 15;
        layer = "top";
        modules-left = ["hyprland/workspaces"];
        modules-center = ["mpris"];
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
            "9" = "九";
            "10" = "十";
            "special" = "・";
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
            "9" = [];
            "10" = [];
          };
        };
        "hyprland/window" = {max-length = 200;};
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
        font-size: 18.5px;
        border: none;
        border-radius: 0;
        min-height: 0;
      }

      window#waybar {
        background-color: rgba(16, 16, 16, 0.8);
        color: @base04;
          transition-property: background-color;
          transition-duration: 0.1s;
        }
      window#waybar.hidden {
        opacity: 0.1;
      }
      #window {
        color: @base04;
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
        border-radius: 6px;
        padding: 2px 10px;
        background-color: @base00;
        border-radius: 8px;

        margin-left: 6px;
        margin-right: 6px;

        margin-top: 5px;
        margin-bottom: 5px;
      }
      #workspaces button {
        color: @base0C;
        box-shadow: inset 0 -3px transparent;

        padding-right: 7px;
        padding-left: 7px;

        transition: all 0.1s cubic-bezier(0.55, -0.68, 0.48, 1.68);
      }
      #workspaces button.empty {
        color: @base04;
        box-shadow: inset 0 -3px transparent;

        padding-right: 7px;
        padding-left: 7px;

        transition: all 0.1s cubic-bezier(0.55, -0.68, 0.48, 1.68);
      }
      #workspaces button.active {
        color: @base0B;
        padding-left: 7px;
        padding-right: 7px;
        transition: all 0.1s cubic-bezier(0.55, -0.68, 0.48, 1.68);
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
      @keyframes blink {
        to {
          background-color: rgba(30, 34, 42, 0.5);
          color: @base07;
        }
      }
      #clock.time {
        color: @base0E;
      }
      #clock.date {
        color: @base08;
      }
      tooltip {
        border-radius: 15px;
        padding: 15px;
        background-color: @base01;
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
      #mpris {
        color: @base09;
      }
    '';
  };
}

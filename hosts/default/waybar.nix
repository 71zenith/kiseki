{pkgs, inputs, config,  ...}:

let
  inherit (config.colorScheme) palette;
in
{
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        height = 15;
        layer = "top";
        modules-left = ["hyprland/workspaces"];
        modules-center = ["mpris"];
        modules-right = ["network" "pulseaudio" "clock#date" "clock#time" "tray" ];
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
        "hyprland/window" = {
          max-length = 200;
        };
        "tray" = {
          spacing = 10;
        };
        "clock#time" = {
          format = "{:%H:%M}";
	  interval = 30;
        };
        "clock#date" = {
          format =  "{:%a %d %b}";
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
            playing = "󰐊";
            paused = "󰏤";
          };
        };
      };
    };
    style = '' 
          * {
            font-family: MonaspiceRn Nerd Font;
            font-size: 18px;
            border: none;
            border-radius: 0;
            min-height: 0;
          }

          window#waybar {
            background-color: rgba(16, 16, 16, 0.8);
	    color: #${palette.base03};
            transition-property: background-color;
            transition-duration: 0.1s;
          }

          window#waybar.hidden {
            opacity: 0.1;
          }

          #window {
            color: #${palette.base03};
          }

          #clock,
          #mpris, 
	  #network,
          #tray,
	  #workspaces,
	  #pulseaudio {
            color: #${palette.base05};
            border-radius: 6px;
            padding: 2px 10px;
            background-color: #${palette.base00};
            border-radius: 8px;

            margin-left: 10px;
            margin-right: 10px;

            margin-top: 5px;
            margin-bottom: 5px;
          }
          #workspaces button {
            color: #${palette.base04};
            box-shadow: inset 0 -3px transparent;

            padding-right: 4px;
            padding-left: 4px;

            margin-left: 0.1em;
            margin-right: 0em;
            transition: all 0.1s cubic-bezier(0.55, -0.68, 0.48, 1.68);
          }
          #workspaces button.active {
            color: #${palette.base0B};
            padding-left: 4px;
            padding-right: 4px;
            margin-left: 0em;
            margin-right: 0em;
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
              color: #abb2bf;
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

          label:focus {
            background-color: #1f232b;
          }

          #tray > .passive {
            -gtk-icon-effect: dim;
          }

          #tray > .needs-attention {
            -gtk-icon-effect: highlight;
            background-color: #eb4d4b;
          }

          #idle_inhibitor {
            background-color: #242933;
          }

          #idle_inhibitor.activated {
            background-color: #ecf0f1;
            color: #2d3436;
          }
          #mpris {
            color: #${palette.base09};
          }
    '';
  };
}

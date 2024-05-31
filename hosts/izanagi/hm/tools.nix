{
  pkgs,
  inputs,
  config,
  lib,
  ...
}: let
  inherit (config.stylix.base16Scheme) palette slug;
  # fcitx5-fluent = pkgs.callPackage ../../modules/nix-os/fcitx-fluent.nix {};
in {
  stylix.targets = {
    zathura.enable = false;
    zellij.enable = false;
    vim.enable = false;
  };

  # TODO: downgrade the package below 5.1.9
  # i18n.inputMethod = {
  #   enabled = "fcitx5";
  #   fcitx5.addons = with pkgs; [fcitx5-mozc fcitx5-gtk fcitx5-fluent];
  # };

  programs = {
    btop = {
      enable = true;
      settings = {
        theme_background = false;
        vim_keys = true;
        rounded_corners = false;
      };
    };

    zellij = {
      enable = true;
      enableZshIntegration = false;
      settings = {
        simplified_ui = true;
        pane_frames = false;
        default_layout = "compact";
        copy_on_select = false;
        hide_session_name = true;
        session_serialization = false;
        ui.pane_frames = {
          hide_session_name = true;
        };
        plugins = ["compact-bar" "session-manager" "filepicker" "welcome-screen"];
        theme = "${slug}";
        themes = {
          ${slug} = with palette; {
            fg = "#${base08}";
            bg = "#${base01}";
            green = "#${base0D}";
            orange = "#${base0A}";
            red = "#${base0A}";
            yellow = "#${base07}";
            blue = "#${base0B}";
            magenta = "#${base09}";
            cyan = "#${base0F}";
            white = "#${base09}";
            black = "#${base01}";
          };
        };
        keybinds = {
          unbind = [
            "Ctrl o"
            "Ctrl t"
          ];
          pane = {
            "bind \"p\"" = {
              SwitchFocus = [];
              SwitchToMode = ["Normal"];
            };
          };
          session = {
            "bind \"Ctrl q\"" = {
              SwitchToMode = ["Normal"];
            };
          };
          "shared_except \"session\" \"locked\"" = {
            "bind \"Ctrl q\"" = {
              SwitchToMode = ["Session"];
            };
          };
          "shared_except \"tab\" \"locked\"" = {
            "bind \"Ctrl w\"" = {
              SwitchToMode = ["Tab"];
            };
          };
        };
      };
    };

    emacs = {
      enable = true;
      package = pkgs.emacs29-pgtk;
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    zathura = {
      enable = true;
      options = with palette; {
        selection-clipboard = "clipboard";
        recolor = "true";
        recolor-keephue = "true";
        font = "${config.stylix.fonts.serif.name} ${toString config.stylix.fonts.sizes.popups}";
        completion-bg = "#${base02}";
        completion-fg = "#${base0C}";
        completion-highlight-bg = "#${base0C}";
        completion-highlight-fg = "#${base02}";
        default-fg = "#${base01}";
        highlight-active-color = "#${base0D}";
        highlight-color = "#${base0A}";
        index-active-bg = "#${base0D}";
        inputbar-bg = "#${base00}";
        inputbar-fg = "#${base04}";
        notification-bg = "#${base09}";
        notification-error-bg = "#${base08}";
        notification-error-fg = "#${base00}";
        notification-fg = "#${base00}";
        notification-warning-bg = "#${base08}";
        notification-warning-fg = "#${base00}";
        recolor-darkcolor = "#${base06}";
        statusbar-bg = "#${base01}";
        default-bg = "rgba(0,0,0,0.7)";
        recolor-lightcolor = "rgba(256,256,256,0)";
      };
      mappings = {
        i = "recolor";
        "[fullscreen] i" = "recolor";
        f = "toggle_fullscreen";
        "[fullscreen] f" = "toggle_fullscreen";
      };
    };

    foot = {
      enable = true;
      settings = {
        main = {pad = "5x5";};
        mouse = {hide-when-typing = "no";};
        key-bindings = {
          scrollback-up-page = "Control+u";
          scrollback-down-page = "Control+d";
          scrollback-up-line = "Mod1+k";
          pipe-command-output = "[wl-copy] Control+Shift+g";
          scrollback-down-line = "Mod1+j";
        };
        cursor = {
          style = "beam";
          color = "${palette.base01} ${palette.base05}";
        };
      };
    };

    yazi = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        manager = {
          ratio = [1 3 3];
          show_hidden = true;
        };
      };
    };
  };

  services = {
    blueman-applet.enable = true;
    hypridle = {
      enable = true;
      settings = {
        general = {
          ignore_dbus_inhibit = false;
        };
        listener = {
          timeout = 300;
          on-timeout = "${lib.getExe inputs.dvd-zig.packages.${pkgs.system}.dvd-zig}";
        };
      };
    };
    mako = {
      enable = true;
      defaultTimeout = 5000;
      maxIconSize = 128;
      borderSize = 3;
      format = ''<span foreground="#${palette.base0B}"><b><i>%s</i></b></span>\n<span foreground="#${palette.base0C}">%b</span>'';
      borderRadius = 10;
      padding = "10";
      width = 330;
      height = 200;
    };
  };
}

{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (config.stylix.base16Scheme) palette;
in {
  imports = [./custom/iamb.nix];

  stylix.targets = {
    zathura.enable = false;
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

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    zathura = {
      enable = true;
      options = with config.lib.stylix.colors.withHashtag; {
        selection-clipboard = "clipboard";
        recolor = "true";
        recolor-keephue = "true";
        font = "${config.stylix.fonts.serif.name} ${toString config.stylix.fonts.sizes.popups}";
        completion-bg = base02;
        completion-fg = base0C;
        completion-highlight-bg = base0C;
        completion-highlight-fg = base02;
        default-fg = base01;
        highlight-active-color = base0D;
        highlight-color = base0A;
        index-active-bg = base0D;
        inputbar-bg = base00;
        inputbar-fg = base04;
        notification-bg = base09;
        notification-error-bg = base08;
        notification-error-fg = base00;
        notification-fg = base00;
        notification-warning-bg = base08;
        notification-warning-fg = base00;
        recolor-darkcolor = base06;
        statusbar-bg = base01;
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

    iamb = {
      enable = true;
      settings = {
        profiles.main = {
          user_id = "@mori.zen:matrix.org";
          settings = {
            image_preview.protocol.type = "sixel";
            message_user_color = true;
            notifications.enabled = true;
            open_command = ["xdg-open"];
            username_display = "displayname";
          };
          layout = {
            style = "config";
            tabs = [
              {window = "!JWluPDcFzVMlxykpoI:matrix.org";}
              {window = "#gen-ani-cli:matrix.org";}
              {window = "@mrfluffy:mrfluffy.xyz";}
              {window = "@nannk:synapse.nannk.xyz";}
            ];
          };
        };
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
          pipe-scrollback = "[sh -c 'cat > /tmp/comsole'] Control+Shift+f";
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
      shellWrapperName = "ya";
      keymap = {
        manager.prepend_keymap = [
          {
            run = ''shell 'for path in "$@"; do echo "file://$path"; done | wl-copy -t text/uri-list' --confirm'';
            on = ["y"];
          }
          {
            run = ''shell "$SHELL" --block --confirm'';
            on = ["<C-s>"];
          }
          {
            run = "plugin --sync max-preview";
            on = ["T"];
          }
        ];
      };
      plugins = {
        max-preview = "${pkgs.yazi-plugins}/share/max-preview.yazi";
      };
      settings = {
        manager = {
          ratio = [1 3 3];
          sort_by = "natural";
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
          on-timeout = "${lib.getExe pkgs.dvd-zig}";
        };
      };
    };
    mako = {
      enable = true;
      defaultTimeout = 5000;
      maxIconSize = 128;
      borderSize = 0;
      format = ''<span foreground="#${palette.base0B}"><b><i>%s</i></b></span>\n<span foreground="#${palette.base0C}">%b</span>'';
      borderRadius = 10;
      padding = "10";
      width = 330;
      height = 200;
    };
  };
}

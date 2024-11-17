{
  pkgs,
  config,
  osConfig,
  lib,
  ...
}: let
  inherit (config.stylix.base16Scheme) palette;
in {
  stylix.targets.zathura.enable = false;

  # i18n.inputMethod = {
  #   enabled = "fcitx5";
  #   fcitx5.addons = with pkgs; [fcitx5-mozc fcitx5-gtk fcitx5-fluent];
  # };

  programs = {
    emacs = {
      enable = true;
      package = pkgs.emacs29-pgtk;
      extraPackages = epkgs: [epkgs.vterm];
    };

    satty = {
      enable = true;
      settings = {
        general = {
          early-exit = true;
          initial-tool = "brush";
          copy-command = "wl-copy";
          annotation-size-factor = 1;
          save-after-copy = false;
          primary-highlighter = "block";
        };
        font.family = config.stylix.fonts.sansSerif.name;
      };
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
        "h" = "feedkeys '<C-Left>'";
        "j" = "feedkeys '<C-Down>'";
        "k" = "feedkeys '<C-Up>'";
        "l" = "feedkeys '<C-Right>'";
        "i" = "recolor";
        "f" = "toggle_fullscreen";
        "[fullscreen] i" = "recolor";
        "[fullscreen] f" = "toggle_fullscreen";
      };
    };

    neovide = {
      enable = true;
      settings = {
        srgb = true;
        font = {
          normal = osConfig.fonts.fontconfig.defaultFonts.monospace;
          size = config.stylix.fonts.sizes.terminal;
          features."${config.stylix.fonts.monospace.name}" = ["+ss01" "+ss07" "+ss02"];
        };
        hinting = "full";
        edging = "antialias";
      };
    };

    foot = {
      enable = true;
      settings = {
        main = {
          pad = "5x5";
          font = lib.mkForce (config.stylix.fonts.monospace.name
            + ":size="
            + toString config.stylix.fonts.sizes.terminal
            + ":"
            + (
              builtins.concatStringsSep ":" (map (name: ("fontfeatures=" + name))
                (map (x: builtins.substring 1 (-1) x) config.programs.neovide.settings.font.features."${config.stylix.fonts.monospace.name}"))
            ));
        };
        mouse = {hide-when-typing = "no";};
        key-bindings = {
          scrollback-up-page = "Control+u";
          scrollback-down-page = "Control+d";
          scrollback-up-line = "Mod1+k";
          pipe-command-output = "[wl-copy] Control+Shift+g";
          pipe-scrollback = "[sh -c 'cat > /tmp/console'] Control+Shift+f";
          scrollback-down-line = "Mod1+j";
        };
        cursor = {
          style = "beam";
          color = "${palette.base01} ${palette.base05}";
        };
      };
    };

    hyprlock = let
      rgb = color: "rgb(${color})";
    in {
      enable = true;
      settings = {
        input-field = {
          size = "300, 60";
          outline_thickness = 4;
          dots_size = 0.30;
          dots_rounding = 0;
          dots_spacing = 0.30;
          dots_center = true;
          outer_color = rgb palette.base01;
          inner_color = rgb palette.base04;
          font_color = rgb palette.base01;
          fade_on_empty = false;
          placeholder_text = "<i>enter pass...</i>";
          hide_input = false;
          rounding = 0;
          check_color = rgb palette.base0A;
          fail_color = rgb palette.base0A;
          fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
          fail_timeout = 1500;
          fail_transition = 200;

          position = "0, -20";
          halign = "center";
          valign = "center";
        };

        label = {
          text = "Hello, $DESC";
          text_align = "center";
          color = rgb palette.base04;
          font_size = 30;
          font_family = "Kaushan Script";

          position = "0, 80";
          halign = "center";
          valign = "center";
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
          on-timeout = "${lib.getExe pkgs.hyprlock}";
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

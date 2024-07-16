{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (config.stylix.base16Scheme) palette;
in {
  imports = [
    ./custom/neovide.nix
    ./custom/satty.nix
  ];

  stylix.targets = {
    zathura.enable = false;
  };

  # TODO: downgrade the package below 5.1.9
  # i18n.inputMethod = {
  #   enabled = "fcitx5";
  #   fcitx5.addons = with pkgs; [fcitx5-mozc fcitx5-gtk fcitx5-fluent];
  # };

  programs = {
    neovide = {
      enable = true;
      settings = {
        srgb = true;
        font = {
          normal = [config.stylix.fonts.monospace.name];
          size = config.stylix.fonts.sizes.terminal;
        };
      };
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

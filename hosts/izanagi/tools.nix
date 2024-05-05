{
  pkgs,
  config,
  ...
}: let
  inherit (config.stylix.base16Scheme) palette;
  fcitx5-fluent = pkgs.callPackage ../../modules/nix-os/fcitx-fluent.nix {};
in {
  imports = [../../modules/home-manager/neovide.nix];
  stylix.targets = {
    zathura.enable = false;
    zellij.enable = false;
    vim.enable = false;
  };
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [fcitx5-mozc fcitx5-gtk fcitx5-fluent];
  };
  programs = {
    btop = {
      enable = true;
      settings = {
        theme_background = false;
        vim_keys = true;
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
        plugins = ["compact-bar" "session-manager" "filepicker" "welcome-screen"];
        theme = "oxocarbon";
        themes = {
          oxocarbon = {
            fg = "#${palette.base08}";
            bg = "#${palette.base01}";
            green = "#${palette.base0D}";
            orange = "#${palette.base0C}";
            red = "#${palette.base0A}";
            yellow = "#${palette.base07}";
            blue = "#${palette.base0B}";
            magenta = "#${palette.base09}";
            cyan = "#${palette.base0F}";
            white = "#${palette.base09}";
            black = "#${palette.base01}";
          };
        };
      };
    };

    helix.enable = true;
    neovide = {
      enable = true;
      settings = {
        srgb = true;
        font = {
          normal = ["${config.stylix.fonts.monospace.name}"];
          size = 21;
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
      options = {
        selection-clipboard = "clipboard";
        recolor = "true";
        recolor-keephue = "true";
        font = "${config.stylix.fonts.serif.name} ${toString config.stylix.fonts.sizes.popups}";
        completion-bg = "#${palette.base02}";
        completion-fg = "#${palette.base0C}";
        completion-highlight-bg = "#${palette.base0C}";
        completion-highlight-fg = "#${palette.base02}";
        default-fg = "#${palette.base01}";
        highlight-active-color = "#${palette.base0D}";
        highlight-color = "#${palette.base0A}";
        index-active-bg = "#${palette.base0D}";
        inputbar-bg = "#${palette.base00}";
        inputbar-fg = "#${palette.base04}";
        notification-bg = "#${palette.base09}";
        notification-error-bg = "#${palette.base08}";
        notification-error-fg = "#${palette.base00}";
        notification-fg = "#${palette.base00}";
        notification-warning-bg = "#${palette.base08}";
        notification-warning-fg = "#${palette.base00}";
        recolor-darkcolor = "#${palette.base06}";
        statusbar-bg = "#${palette.base01}";
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
        main = {pad = "10x10";};
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
          color = "282a36 f8f8f2";
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
  services.mako = {
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
}

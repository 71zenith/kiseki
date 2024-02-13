{ pkgs, config, ... }:
let inherit (config.colorScheme) palette;
in {

  stylix.targets.zathura.enable = false;
  programs = {
    btop = {
      enable = true;
      settings = {
        color_theme = "tomorrow-night";
        theme_background = false;
        vim_keys = true;
      };
    };
    emacs = {
      enable = true;
      package = pkgs.emacs29;
    };

    zathura = {
      enable = true;
      options = {
        selection-clipboard = "clipboard";
        recolor = "true";
        recolor-keephue = "true";
        font = "Open Sans 14";
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
        main = { pad = "10x10"; };
        mouse = { hide-when-typing = "no"; };
        key-bindings = {
          scrollback-up-page = "Control+u";
          scrollback-down-page = "Control+d";
          scrollback-up-line = "Mod1+k";
          scrollback-down-line = "Mod1+j";
        };
        cursor = {
          style = "beam";
          color = "282a36 f8f8f2";
        };
      };
    };

    rofi = {
      enable = true;
      cycle = true;
      package = pkgs.rofi-wayland;
      plugins = with pkgs; [ rofi-emoji rofi-calc ];
      extraConfig = {
        modi = "drun,window,calc,emoji";
        sidebar-mode = true;
        show-icons = true;
        kb-remove-char-back = "BackSpace";
        kb-remove-to-eol = "Control+x";
        kb-accept-entry = "Control+m,Return,KP_Enter";
        kb-mode-next = "Control+l";
        kb-mode-previous = "Control+h";
        kb-row-up = "Control+k";
        kb-row-down = "Control+j";
        kb-mode-complete = "Control+p";
      };
    };
  };
  services.mako = {
    enable = true;
    defaultTimeout = 5000;
    borderSize = 3;
    width = 330;
    height = 200;
  };
}

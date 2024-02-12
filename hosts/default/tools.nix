{ pkgs, ... }: {
  programs.btop = {
    enable = true;
    settings = {
      color_theme = "tomorrow-night";
      theme_background = false;
      vim_keys = true;
    };
  };

  programs.zathura = {
    enable = true;
    options = {
      selection-clipboard = "clipboard";
      recolor = "true";
      font = "Noto Sans 14";
    };
    mappings = {
      i = "recolor";
      "[fullscreen] i" = "recolor";
      f = "toggle_fullscreen";
      "[fullscreen] f" = "toggle_fullscreen";
    };
  };

  programs.git = {
    enable = true;
    userName = "zen";
    userEmail = "71zenith@proton.me";
  };

  programs.foot = {
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

  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    plugins = with pkgs; [ rofi-top rofi-emoji rofi-calc rofi-file-browser ];
    extraConfig = {
      modi = "drun,run";
      sidebar-mode = true;
      show-icons = true;
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

{
  pkgs,
  inputs,
  config,
  ...
}: let
  inherit (config.colorScheme) palette;
in {
  imports = [../../modules/home-manager/neovide.nix];
  stylix.targets.zathura.enable = false;
  stylix.targets.vim.enable = false;
  programs = {
    btop = {
      enable = true;
      settings = {
        theme_background = false;
        vim_keys = true;
      };
    };

    neovide = {
      enable = true;
      settings = {
        srgb = true;
        font = {
          normal = ["Iosevka Term Medium"];
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
        font = "Google Sans 14";
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
      package = inputs.nixpkgs-wayland.packages.${pkgs.system}.foot;
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
    width = 330;
    height = 200;
  };
}

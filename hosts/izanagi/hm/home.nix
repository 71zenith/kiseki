{
  pkgs,
  config,
  myUserName,
  ...
}: let
  inherit (config.stylix.base16Scheme) palette;
in {
  imports = [
    ./tools.nix
    ./mpv.nix
    ./zsh.nix
    ./waybar.nix
    ./nvim.nix
    ./git.nix
    ./rofi.nix
    ./xdg.nix
    ./firefox.nix
    ./spotify-player.nix
    ./hyprland.nix
  ];

  # NOTE: virt-manager fix
  dconf = {
    enable = true;
    settings = {
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = ["qemu:///system"];
        uris = ["qemu:///system"];
      };
    };
  };

  home = {
    username = "${myUserName}";

    stateVersion = "24.11";

    pointerCursor = {
      x11.enable = true;
      gtk.enable = true;
    };
  };

  xdg.configFile = {
    "nixpkgs/config.nix".source = ./nixpkgs.nix;

    "glava/bars.glsl".enable = true;
    "glava/bars.glsl".text = ''
      #define C_LINE 2
      #define BAR_WIDTH 8
      #define BAR_GAP 5
      #define BAR_OUTLINE #${palette.base02}
      #define BAR_OUTLINE_WIDTH 0
      #define AMPLIFY 400
      #define USE_ALPHA 0
      #define GRADIENT_POWER 500
      #define GRADIENT (d / GRADIENT_POWER + 1)
      #define COLOR (#${palette.base07}* GRADIENT)
      #define INVERT 0
      #define DIRECTION 0
      #define FLIP 0
      #define MIRROR_YX 0
    '';
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk3";
  };

  gtk = {
    enable = true;
    iconTheme = {
      name = "Zafiro-icons-Dark";
      package = pkgs.zafiro-icons;
    };
  };

  xresources.properties = with palette; {
    "bar.background" = "#${base02}";
    "bar.foreground" = "#${base0B}";
    "bar.font" = "${config.stylix.fonts.serif.name} ${toString config.stylix.fonts.sizes.desktop}";
    "window.foreground" = "#${base04}";
    "window.background" = "#${base02}";
    "mark.background" = "#${base0A}";
  };
}

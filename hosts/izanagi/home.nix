{
  pkgs,
  config,
  ...
}: let
  inherit (config.stylix.base16Scheme) palette;
in {
  imports = [
    ./tools.nix
    ./mpv.nix
    ./shell.nix
    ./waybar.nix
    ./nvim.nix
    ./git.nix
    ./rofi.nix
    ./xdg.nix
    ./spotify-player.nix
    ./hyprland.nix
  ];

  programs.home-manager.enable = true;

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };

  home = {
    username = "zen";
    homeDirectory = "/home/zen";
    sessionVariables = {EDITOR = "nvim";};

    stateVersion = "24.05";

    pointerCursor = {
      x11.enable = true;
      gtk.enable = true;
    };
  };

  nixpkgs.config = import ./nixpkgs.nix;
  xdg.configFile."nixpkgs/config.nix".source = ./nixpkgs.nix;

  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style.name = "breeze";
  };

  gtk = {
    enable = true;
    iconTheme = {
      name = "Zafiro-icons-Dark";
      package = pkgs.zafiro-icons;
    };
  };

  xresources.properties = {
    "bar.background" = "#${palette.base02}";
    "bar.foreground" = "#${palette.base0B}";
    "bar.font" = "${config.stylix.fonts.serif.name} ${toString config.stylix.fonts.sizes.desktop}";
    "window.foreground" = "#${palette.base04}";
    "window.background" = "#${palette.base02}";
    "mark.background" = "#${palette.base0A}";
  };
}

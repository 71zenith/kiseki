{
  pkgs,
  config,
  lib,
  osConfig,
  ...
}: let
  scripts = import ../../../pkgs/scripts.nix {inherit pkgs lib;};
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
    username = osConfig.vals.myUserName;

    stateVersion = "24.11";

    pointerCursor = {
      x11.enable = true;
      gtk.enable = true;
    };

    packages = [
      scripts._4khd
    ];
  };

  xdg.configFile."nixpkgs/config.nix".source = ./nixpkgs.nix;

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

  xresources.properties = with config.lib.stylix.colors.withHashtag; {
    "bar.background" = base02;
    "bar.foreground" = base0B;
    "bar.font" = "${config.stylix.fonts.serif.name} ${toString config.stylix.fonts.sizes.desktop}";
    "window.foreground" = base04;
    "window.background" = base02;
    "mark.background" = base0A;
  };
}

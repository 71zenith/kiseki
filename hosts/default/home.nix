{
  pkgs,
  inputs,
  config,
  ...
}: let
  inherit (config.colorScheme) palette;
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
    inputs.nix-colors.homeManagerModules.default
  ];

  programs.home-manager.enable = true;

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };

  colorScheme = inputs.nix-colors.colorSchemes.oxocarbon-dark;

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

  qt = {enable = true;};
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
    "bar.font" = "Google Sans-13";
    "window.foreground" = "#${palette.base04}";
    "window.background" = "#${palette.base02}";
    "mark.background" = "#${palette.base0A}";
  };
}

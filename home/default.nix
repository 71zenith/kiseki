{
  pkgs,
  config,
  lib,
  myUserName,
  osConfig,
  ...
}: let
  scripts = import ../pkgs/scripts.nix {inherit pkgs lib config;};
in {
  stylix.targets.kde.enable = false;
  imports = [
    ./modules
    ./cli.nix
    ./gui.nix
    ./mpv.nix
    ./zsh.nix
    ./waybar.nix
    ./nvim.nix
    ./git.nix
    ./rofi.nix
    ./eww.nix
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
    username = myUserName;

    stateVersion = "24.11";

    sessionPath = [
      "${config.xdg.configHome}/emacs/bin"
    ];

    packages = [
      scripts._4khd
    ];

    sessionVariables = {
      MANPAGER = "less -R --use-color -Dd+m -Du+b -DP+g";
      MANROFFOPT = "-P -c";
      LESS = "-R --use-color";
    };
  };
  fonts.fontconfig = {inherit (osConfig.fonts.fontconfig) defaultFonts;};

  xdg.configFile."nixpkgs/config.nix".source = ./nixpkgs.nix;

  qt = {
    enable = true;
    platformTheme.name = "gtk3";
  };

  stylix.targets.gtk.extraCss = with config.lib.stylix.colors.withHashtag; ''
    @define-color accent_color ${base0A};
    @define-color accent_bg_color ${base0A};
  '';
  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };
  xdg.portal = {
    enable = true;
    config.common.default = ["hyprland" "gtk"];
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [xdg-desktop-portal-hyprland xdg-desktop-portal-gtk];
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

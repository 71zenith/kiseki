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

    packages = [
      scripts._4khd
    ];
    sessionVariables = {
      LIBVA_DRIVER_NAME = "nvidia";
      XDG_SESSION_TYPE = "wayland";
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      WLR_NO_HARDWARE_CURSORS = "1";
      NIXOS_OZONE_WL = "1";
      MOZ_ENABLE_WAYLAND = "1";
      MOZ_WEBRENDER = "1";
      _JAVA_AWT_WM_NONREPARENTING = "1";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      QT_QPA_PLATFORM = "wayland;xcb";
      QT_QPA_PLATFORMTHEME = "gtk3";
      ELECTRON_OZONE_PLATFORM_HINT = "wayland";
      DISABLE_QT5_COMPAT = "0";
      CALIBRE_USE_DARK_PALETTE = "1";
      SDL_VIDEODRIVER = "wayland";
      GDK_BACKEND = "wayland";
    };
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

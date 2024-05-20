{
  pkgs,
  inputs,
  ...
}: let
  fonts = pkgs.callPackage ../../../pkgs/fonts.nix {};
in {
  stylix = {
    polarity = "dark";
    image = ../../../resources/wallpapers/oxocarbon.png;
    base16Scheme = inputs.nix-colors.colorSchemes.oxocarbon-dark;
    fonts = {
      serif = {
        package = fonts;
        name = "Google Sans";
      };
      sansSerif = {
        package = fonts;
        name = "Google Sans";
      };
      monospace = {
        package = pkgs.iosevka-bin;
        name = "Iosevka Term Oblique";
      };
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
      sizes = {
        applications = 13;
        desktop = 12;
        popups = 14;
        terminal = 15;
      };
    };
    opacity = {
      terminal = 0.80;
      popups = 0.90;
      desktop = 0.80;
    };
    cursor = {
      package = pkgs.phinger-cursors;
      name = "phinger-cursors-light";
      size = 32;
    };
  };
}

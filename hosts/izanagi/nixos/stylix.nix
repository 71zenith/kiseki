{
  pkgs,
  inputs,
  ...
}: let
  fonts = pkgs.callPackage ../../../modules/nix-os/fonts.nix {};
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
        package = pkgs.iosevka-comfy.comfy;
        name = "Iosevka Comfy";
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
    opacity.terminal = 0.85;
    cursor = {
      package = pkgs.phinger-cursors;
      name = "phinger-cursors-light";
      size = 32;
    };
  };
}

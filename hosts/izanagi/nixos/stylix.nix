{
  pkgs,
  inputs,
  ...
}: {
  stylix = {
    polarity = "dark";
    image = "${pkgs.my-walls}/share/wallpapers/oxocarbon.png";
    base16Scheme = inputs.nix-colors.colorSchemes.oxocarbon-dark;
    fonts = {
      serif = {
        package = pkgs.my-fonts;
        name = "Kollektif";
      };
      sansSerif = {
        package = pkgs.my-fonts;
        name = "Kollektif";
      };
      monospace = {
        package = pkgs.iosevka-bin;
        name = "Iosevka Term Medium";
      };
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
      sizes = {
        applications = 14;
        desktop = 14;
        popups = 14;
        terminal = 14;
      };
    };
    opacity = {
      terminal = 0.80;
      popups = 0.90;
      desktop = 0.90;
    };
    cursor = {
      package = pkgs.phinger-cursors;
      name = "phinger-cursors-light";
      size = 32;
    };
  };
}

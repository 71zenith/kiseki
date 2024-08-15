{
  pkgs,
  inputs,
  ...
}: {
  stylix = {
    enable = true;
    polarity = "dark";
    image = "${pkgs.my-walls}/share/wallpapers/oxocarbon.png";
    base16Scheme = inputs.nix-colors.colorSchemes.oxocarbon-dark;
    fonts = rec {
      serif = {
        package = pkgs.my-fonts;
        name = "Kollektif";
      };
      sansSerif = serif;
      monospace = {
        package = pkgs.miracode;
        name = "Miracode";
      };
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
      sizes = {
        applications = 14;
        desktop = 14;
        popups = 14;
        terminal = 15;
      };
    };
    opacity = {
      terminal = 0.90;
      popups = 0.90;
      desktop = 0.90;
    };
    cursor = {
      package = pkgs.phinger-cursors;
      name = "phinger-cursors-light";
      size = 32;
    };
  };
  fonts = {
    fontconfig.defaultFonts = rec {
      sansSerif = ["Kollektif" "Mamelon"];
      serif = sansSerif;
      emoji = ["Noto Color Emoji"];
    };
    packages = with pkgs; [
      my-fonts
      (nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];})
    ];
  };
}

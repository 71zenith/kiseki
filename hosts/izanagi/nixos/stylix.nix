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
        name = "PlemolJP Console NF Medium";
      };
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
      sizes = {
        applications = 15;
        desktop = 15;
        popups = 15;
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

  fonts.packages = with pkgs; [
    (nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];})
  ];
}

{
  pkgs,
  inputs,
  ...
}: {
  # specialisation = {
  #   "light".configuration = {
  #     stylix.base16Scheme = inputs.nix-colors.colorSchemes.oxocarbon-light;
  #   };
  # };
  stylix = {
    polarity = "dark";
    image = "${pkgs.my-walls}/share/wallpapers/oxocarbon.png";
    base16Scheme = inputs.nix-colors.colorSchemes.oxocarbon-dark;
    fonts = rec {
      serif = {
        package = pkgs.my-fonts;
        name = "Kollektif";
      };
      sansSerif = {
        package = pkgs.my-fonts;
        inherit (serif) name;
      };
      monospace = {
        package = pkgs.my-fonts;
        name = "Agave";
      };
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
      sizes = {
        applications = 14;
        desktop = 14;
        popups = 14;
        terminal = 16;
      };
    };
    opacity = {
      terminal = 0.80;
      popups = 0.90;
      desktop = 0.75;
    };
    cursor = {
      package = pkgs.phinger-cursors;
      name = "phinger-cursors-light";
      size = 32;
    };
  };
  fonts = {
    fontconfig.defaultFonts = rec {
      sansSerif = ["Kollektif" "umeboshi"];
      serif = sansSerif;
      emoji = ["Noto Color Emoji"];
      monospace = ["Agave"];
    };

    packages = with pkgs; [
      my-fonts
      (nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];})
    ];
  };
}
